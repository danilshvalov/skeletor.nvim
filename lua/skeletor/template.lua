local scan = require("plenary.scandir")
local Path = require("plenary.path")
local Job = require("plenary.job")
local async = require("plenary.async")

local utils = require("skeletor.utils")
local config = require("skeletor.config")
local log = require("skeletor.log")

config.options.user_licenses = {}

local function get_filename(path)
    return path:match("^.+/(.+)$")
end

local function load_licenses()
    config.options.user_licenses = {}
    scan.scan_dir(config.options.licenses.directory, {
        on_insert = function(path)
            config.options.user_licenses[get_filename(path)] = path
        end,
    })
    return config.options.user_licenses
end

local Template = {}

function Template:new(template_data)
    local obj = {}

    obj.template = vim.deepcopy(template_data)
    obj.title = template_data.title
    obj.name = template_data.name

    setmetatable(obj, self)
    self.__index = self

    config.options.user_templates[obj.name] = obj

    return obj
end

function Template:__apply_substitutions(content)
    for pattern, substitute in pairs(self.template.substitutions) do
        pattern = utils.literalize_string(pattern)
        content = content:gsub(pattern, substitute)
    end
    return content
end

function Template:__make_output_path(file_path, output_filename)
    local relative_file_path = file_path:make_relative(self.template.path:absolute())
    relative_file_path = self:__apply_substitutions(relative_file_path)

    local output_file_path
    if output_filename then
        output_file_path = self.output_path:joinpath(output_filename)
    else
        output_file_path = self.output_path:joinpath(relative_file_path)
    end

    return output_file_path
end

function Template:__process_file(file_path, output_filename)
    file_path:read(function(content)
        content = self:__apply_substitutions(content)

        local output_file_path = self:__make_output_path(file_path, output_filename)

        output_file_path:parent():mkdir()
        output_file_path:write(content, "w")
    end)
end

function Template:__process_files(output_path)
    self.output_path = output_path

    scan.scan_dir(self.template.path:absolute(), {
        hidden = true,
        on_insert = function(file_path)
            file_path = Path:new(file_path)
            self:__process_file(file_path)
        end,
    })

    if self.template.init_git then
        Job:new({
            command = "git",
            args = { "init" },
            cwd = output_path:absolute(),
        }):start()
    end

    if type(self.template.license) == "table" then
        self:__process_file(self.template.license, "LICENSE")
    end

    if self.template.after_creation then
        self.template.after_creation({
            cwd = output_path:absolute(),
        })
    end
end

function Template:__validate_license()
    if not config.options.user_licenses[self.template.license] then
        log.error("Unable to find the licence file:", self.template.license)
    else
        self.template.license = Path:new(config.options.user_licenses[self.template.license])
    end
end

function Template:__prepare_license()
    load_licenses()

    if self.template.license and type(self.template.license) == "boolean" then
        self.template.license = utils.select_item("Select license", vim.tbl_keys(config.options.user_licenses))
    end
    self:__validate_license()
end

function Template:__prepare_template()
    for pattern, substitution in pairs(self.template.substitutions) do
        if type(substitution) == "function" then
            self.template.substitutions[pattern] = substitution()
        end
    end
end

function Template:create(output_path)
    async.run(function()
        self:__prepare_template()
        self:__prepare_license()
        self:__process_files(output_path)
        log.info("The project was successfully created!")
    end)
end

return Template

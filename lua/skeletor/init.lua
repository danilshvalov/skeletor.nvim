local Path = require("plenary.path")
local async = require("plenary.async")

local log = require("skeletor.log")
local config = require("skeletor.config")
local Template = require("skeletor.template")
local utils = require("skeletor.utils")

local M = {}

M.define_template = function(name, opts)
    opts = vim.tbl_deep_extend("force", config.options.templates, opts or {})

    if opts.path then
        opts.path = Path:new(opts.path)
    else
        opts.path = Path:new(config.options.templates.directory, name)
    end

    if not opts.path:exists() then
        log.error("Unable to open the template directory:", opts.path:absolute())
        return
    end

    opts.name = name
    if not opts.title then
        opts.title = name
    end

    opts.substitutions = opts.substitutions or {}

    return Template:new(opts)
end

local get_template_titles = function()
    local titles = {}

    for name, info in pairs(config.options.user_templates) do
        titles[info.title] = name
    end

    return titles
end

M.create_project = function(opts)
    opts = opts or {}

    local path = opts.path
    if not path or path == "" then
        path = vim.fn.getcwd()
    else
        path = vim.fn.expand(path)
    end
    path = Path:new(path)
    path:mkdir()

    local template_title = opts.template_title
    async.run(function()
        local template_titles = get_template_titles()

        if not template_title then
            template_title = utils.select_item("Select template", vim.tbl_keys(template_titles))
        end

        local template_name = template_titles[template_title]
        config.options.user_templates[template_name]:create(path)
    end)
end

M.setup = function(options)
    config.setup(options)

    vim.api.nvim_create_user_command("Skeletor", function(opts)
        M.create_project({ path = opts.args })
    end, {
        nargs = "?",
        complete = "file",
    })
end

M.read_input = utils.read_input
M.select_item = utils.select_item

return M

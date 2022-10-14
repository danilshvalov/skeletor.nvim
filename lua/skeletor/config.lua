local Job = require("plenary.job")

local M = {}

local default_config = {
    templates = {
        directory = vim.fn.stdpath("config") .. "/templates",
        init_git = true,
        license = true,
        substitutions = {
            ["__USER-NAME__"] = function()
                if vim.fn.executable("git") then
                    local result, _ = Job:new({
                        command = "git",
                        args = { "config", "user.name" },
                    }):sync()

                    if #result > 0 then
                        return result[1]
                    end
                end
            end,
            ["__YEAR__"] = vim.fn.strftime("%Y"),
        },
    },
    licenses = {
        directory = vim.fn.stdpath("config") .. "/templates/licenses",
    },
    user_templates = {},
}

local function validate_config(config)
    local templates = config.templates
    local licenses = config.licenses

    vim.validate({
        templates = { config.templates, "table" },
        licences = { licenses, "table" },
    })

    vim.validate({
        directory = { templates.directory, "string" },
        init_git = { templates.init_git, "boolean" },
        license = { templates.license, { "string", "boolean" }, true },
        after_creation = { templates.after_creation, "function", true },
    })

    vim.validate({
        directory = { licenses.directory, "string" },
    })
end

M.options = {}

M.setup = function(config)
    M.options = vim.tbl_deep_extend("force", default_config, config or {})
    validate_config(M.options)
end

return M

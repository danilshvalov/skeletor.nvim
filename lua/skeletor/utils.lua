local async = require("plenary.async")

local M = {}

M.literalize_string = function(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)
        return "%" .. c
    end)
end

M.read_input = async.wrap(function(prompt, callback)
    vim.ui.input({ prompt = prompt }, function(input)
        if input then
            callback(input)
        end
    end)
end, 2)

M.select_item = async.wrap(function(prompt, items, callback)
    vim.ui.select(items, {
        prompt = prompt,
    }, function(choice)
        if choice then
            callback(choice)
        end
    end)
end, 3)

return M

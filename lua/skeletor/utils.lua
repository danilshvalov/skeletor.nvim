local promise = require("promise")

local M = {}

M.literalize_string = function(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)
    return "%" .. c
  end)
end

M.read_input = function(prompt)
  return promise(function(resolve, _)
    vim.ui.input({ prompt = prompt }, function(input)
      if input then
        resolve(input)
      end
    end)
  end)
end

M.select_item = function(prompt, items)
  return promise(function(resolve, _)
    vim.ui.select(items, {
      prompt = prompt,
    }, function(choice)
      if choice then
        resolve(choice)
      end
    end)
  end)
end

return M

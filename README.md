<h1 align="center"><code>skeletor.nvim</code></h1>
<p align="center">⚡ Project template generator for Neovim ⚡</p>

![skeletor](https://user-images.githubusercontent.com/57654917/195681224-e4d36de7-4310-4a4d-ae63-6a0a07589966.jpg)

## 🔗 Requirements

* Neovim >= 0.8.0
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim/)

## 📦 Installation

```lua
use({
    "danilshvalov/skeletor.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
        require("skeletor").setup()
    end,
})
```

## Usage

Use `:Skeletor $path$` to create a new project at path `$path$` based on an existing template.

## Configuration

```lua
require("skeletor").setup({
    -- global templates settings
    templates = {
        -- path to templates directory
        directory = vim.fn.stdpath("config") .. "/templates",
        -- init git after
        init_git = true,
        -- add license
        license = true,
        -- global substitutions
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
    -- global license settings
    licenses = {
        -- path to licenses directory
        directory = vim.fn.stdpath("config") .. "/templates/licenses",
    },
})
```

## Templates creation

The following code is an example of defining a new template:

```lua
local skeletor = require("skeletor.nvim")

skeletor.define_template("nvim-plugin", {
    title = "Neovim plugin"
    license = "MIT",
    substitutions = {
        ["__PROJECT-NAME__"] = function()
          return skeletor.read_input("Project name: ")
        end,
    },
    after_creation = function()
        vim.notify("Hello World!")
    end,
})
```

The meaning of the fields can be found in the following table:

| Field            | Type                  | Description                                                                                                                                                                                                              |
|------------------|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `title`          | `string`              | The header that will be used when selecting the template. <br> If not defined, the template name is used as the title.                                                                                                   |
| `license`        | `string` or `boolean` | The license that will be added to the project. <br> If `string`, then a specific license type will be used. <br> If `true`, then a license selection will be offered. <br> If `false`, then a license will not be added. |
| `substitutions`  | `table`               | Table of substitutions. See below for details.                                                                                                                                                                           |
| `after_creation` | `function`            | The function that will be called after the template is created.                                                                                                                                                          |

## Substitutions

TODO

## 🔥 Inspired by

* [skeletor.el](https://github.com/chrisbarrett/skeletor.el) - Powerful project skeletons for Emacs.

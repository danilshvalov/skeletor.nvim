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
    title = "Neovim plugin",
    license = "MIT",
    substitutions = {
        ["__USER-NAME__"] = "Tomas Anderson",
        ["__PROJECT-NAME__"] = function()
          return skeletor.read_input("Project name: ")
        end,
        ["__DATETIME__"] = function()
          return vim.fn.strftime("%Y-%m-%d_%H:%M:%S")
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
| `substitutions`  | `table`               | Table of substitutions. See [below](#substitutions) for details.                                                                                                                                                                           |
| `after_creation` | `function`            | The function that will be called after the template is created.                                                                                                                                                          |

## Substitutions

### Concept

Skeletor can perform text substitutions when it creates new projects. This makes it possible to refer to the name of the project, add time-stamps and customise the contents of files according to user input when a project is created.

Skeletor replaces all templates with their values for both the contents of files and the names of files and directories.

Thus, the following structure:

```
some-template
├── some-file
└── __SOME-SUBSTITUTION__
```

To the following structure:

```
some-template
├── some-file
└── VALUE-OF-SUBSTITUTION
```

If we are talking about the contents of a file, for example:

```
This is a file with __SOME-SUBSTITUTION__.
```

Then the same rule applies here:

```
This is a file with VALUE-OF-SUBSTITUTION.
```

### Example

Let's look at an example. Let's create the following template:

```lua
local skeletor = require("skeletor.nvim")

skeletor.define_template("nvim-plugin", {
    -- ...
    substitutions = {
        ["__USER-NAME__"] = "Tomas Anderson",
        ["__PROJECT-NAME__"] = function()
          return skeletor.read_input("Project name: ")
        end,
        ["__DATETIME__"] = function()
          return vim.fn.strftime("%Y-%m-%d_%H:%M:%S")
        end,
    },
    -- ...
})
```

Let the template have the following structure:

```
nvim-plugin
├── README.md
├── doc
│   └── __PROJECT-NAME__.txt
└── lua
    └── __PROJECT-NAME__
        └── init.lua
```

Also let the README file be with the following contents:

```md
The plugin `__PROJECT-NAME__` was created by __USER-NAME__ at __DATETIME__.
```

Now let's create this template. Choose `/tmp/nvim-plugin/` as the directory and call the command `Skeletor /tmp/nvim-plugin/`. After that, you will be prompted to select a template. Let's choose `test` as the project name. After creating the project, you will receive the following file structure:

```
nvim-plugin
├── README.md
├── doc
│   └── test.txt
└── lua
    └── test
        └── init.lua
```

And inside the README there will be the following text:

```md
The plugin `test` was created by Tomas Anderson at 2022-10-18_01:34:02.
```

As you could understand, all the contents of the files, as well as the names of files and directories, were replaced with their template values.

## 🔥 Inspired by

* [skeletor.el](https://github.com/chrisbarrett/skeletor.el) - Powerful project skeletons for Emacs.

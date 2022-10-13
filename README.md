<h1 align="center"><code>skeletor.nvim</code></h1>
<p align="center">⚡ Project template generator for Neovim ⚡</p>

![skeletor](https://user-images.githubusercontent.com/57654917/195681224-e4d36de7-4310-4a4d-ae63-6a0a07589966.jpg)


## ⛓ Requirements

* Neovim >= 0.8.0
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim/)
* [promise-async](https://github.com/kevinhwang91/promise-async)

## 📦 Installation

```lua
use({
    "danilshvalov/skeletor.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "kevinhwang91/promise-async",
    },
    config = function()
        require("skeletor").setup()
    end,
})
```

## 🔥 Inspired by

* [skeletor.el](https://github.com/chrisbarrett/skeletor.el) - Powerful project skeletons for Emacs.

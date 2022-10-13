# skeletor.nvim

Skeletor is a project template generator for Neovim.

## ⚡️ Requirements

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

* [skeleton.el](https://github.com/chrisbarrett/skeletor.el) -- Powerful project skeletons for Emacs.

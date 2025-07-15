# nvim-rename-plugin

A simple Neovim plugin to rename the current buffer’s file.

## Usage

Call `:lua require('rename').rename_current_file()` or use the default keymap `<leader>rn` after setup.

## Installation

Use your favorite plugin manager, e.g.:

```lua
use {
  'cushydigit/nvim-rename-plugin',
  config = function()
    require('rename').setup()
  end,
}

# slides.nvim

[Slides](https://github.com/maaslalani/slides) presentation in your Neovim.


## Prerequisites

- `Neovim >= 0.5.0`
- [`Slides`](https://github.com/maaslalani/slides)

## Installation

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'aspeddro/slides.nvim',
  config = function ()
    require'slides'.setup{}
  end
}
```

## Configuration

```lua
require'slides'.setup{
  bin = 'slides' -- default config, path to binary
}
```

## Usage

Open current buffer

```
:Slides
```

```
:Slides [path/to/file.md]
```

Create a mapping:

```lua
-- 'n' = normal mode
vim.api.nvim_set_keymap('n', "<leader>s", ":Slides<CR>", {silent = true, noremap = true})
```

use `q` and `ctrl + c` to close slide

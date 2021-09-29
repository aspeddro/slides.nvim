# slides.nvim

[Slides](https://github.com/maaslalani/slides) presentation in your Neovim.

![image](https://user-images.githubusercontent.com/16160544/135359624-a4772255-0fe7-4c3d-ba94-faa79ef66bce.png)

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

Open current file

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

use `q` or `ctrl + c` to close slide

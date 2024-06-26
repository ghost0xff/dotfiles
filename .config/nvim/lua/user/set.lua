vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.wo.number = true
vim.wo.relativenumber = true

vim.g.netrw_banner = 0
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

-- commented cause I have a keymap that handles yanking/pasting into clipboard
-- vim.o.clipboard = 'unnamedplus'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'



-- searching
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- UI
vim.o.termguicolors = true
vim.opt.fillchars = { stlnc = '─', stl = '─' }

-- miscellaneous
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.colorcolumn = "80"
vim.o.signcolumn = "auto"

-- expo dev
vim.o.swapfile = false


-- vim.wo.signcolumn = 'yes'
vim.opt.isfname:append("@-@")
-- vim.opt.scrolloff = 999

-- tabs
-- vim.o.shiftwidth = 4
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
vim.o.expandtab = true


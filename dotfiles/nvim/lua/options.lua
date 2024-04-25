-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- OPTIONS/SETTINGS
local opt = vim.opt

opt.autowrite = true
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.laststatus = 0
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.pumheight = 10
opt.scrolloff = 5
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "terminal" }
opt.shiftround = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 100
opt.ttimeoutlen = 0
opt.undofile = true
opt.updatetime = 200
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
opt.hlsearch = true
opt.fillchars = { eob = " " }

if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

require("options")

-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "[l]azy (plugin manager)", noremap = true, silent = true })
require("lazy").setup({
	-- misc
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "nvim-tree/nvim-web-devicons" },
	{ "tpope/vim-sleuth" },
	{ "christoomey/vim-tmux-navigator" },

	-- editor
	{ "folke/which-key.nvim" },
	{ "folke/trouble.nvim" },
	{ "folke/persistence.nvim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "echasnovski/mini.nvim" },
	{ "lewis6991/gitsigns.nvim" },

	-- lsp
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "stevearc/conform.nvim" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "neovim/nvim-lspconfig" },
}, {})

vim.cmd.colorscheme("catppuccin-frappe")
require("editor")
require("lsp")

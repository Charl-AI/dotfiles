require("options")
require("keymaps")
require("autocmds")

-- PLUGINS
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

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "stevearc/conform.nvim" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "echasnovski/mini.nvim" },
	{ "tpope/vim-sleuth" },
	{ "christoomey/vim-tmux-navigator", event = { "BufReadPost", "BufNewFile" } },
	{ "folke/which-key.nvim", event = "VeryLazy" },
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
	{ "folke/trouble.nvim" },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "help", "terminal" } },
		keys = {
			{
				"<leader>r",
				function()
					require("persistence").load()
				end,
				desc = "[r]estore session",
			},
		},
	},
}, {})

vim.cmd.colorscheme("catppuccin-frappe")
require("editor")
require("lsp")

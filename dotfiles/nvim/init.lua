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
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
	},
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "stevearc/conform.nvim" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
	{ "echasnovski/mini.nvim" },
	{ "tpope/vim-sleuth" },
	{
		"christoomey/vim-tmux-navigator",
		event = { "BufReadPost", "BufNewFile" },
	},
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			local keymaps = {
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader>c"] = { name = "+code" },
				["<leader>g"] = { name = "+git" },
				["<leader>s"] = { name = "+search (mini.Pick)" },
			}
			wk.register(keymaps)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(_)
				local gs = package.loaded.gitsigns
				local function map(mode, lhs, rhs, opts)
					local options = { noremap = true, silent = true }
					if opts then
						options = vim.tbl_extend("force", options, opts)
					end
					vim.keymap.set(mode, lhs, rhs, options)
				end

				map("n", "[h", gs.prev_hunk, { desc = "Prev Hunk" })
				map("n", "]h", gs.next_hunk, { desc = "Next Hunk" })

				map({ "n", "v" }, "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
				map({ "n", "v" }, "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
				map({ "n", "v" }, "<leader>gu", gs.undo_stage_hunk, { desc = "Unstage hunk" })
				map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>gU", gs.reset_buffer_index, { desc = "Unstage buffer" })
				map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle inline blame" })
				map("n", "<leader>gd", gs.diffthis, { desc = "Diff line" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame line" })
			end,
		},
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true, auto_preview = false },
		keys = {
			{
				"<leader>d",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "[d]iagnostics (buffer)",
			},
			{
				"<leader>D",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "[D]iagnostics (workspace)",
			},
		},
	},
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

require("editor")
require("lsp")

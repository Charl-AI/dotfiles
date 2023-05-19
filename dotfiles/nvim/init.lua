-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")

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

-- we install and set up the lsp here
-- other plugins are configured in the lua/plugins/ dir
require("lazy").setup({
	{ import = "plugins" },

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "zbirenbaum/copilot.lua" },
			{ "zbirenbaum/copilot-cmp" },
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "jay-babu/mason-null-ls.nvim" },
			{ "j-hui/fidget.nvim" },
			{ "hrsh7th/cmp-path" },
		},
	},
}, {})

require("fidget").setup()
require("mason").setup({
	ui = {
		border = "rounded",
	},
})
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason (LSP GUI)" })

require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})
require("copilot_cmp").setup()

local lsp = require("lsp-zero").preset({
	manage_nvim_cmp = {
		set_basic_mappings = false,
	},
})

lsp.on_attach(function(client, bufnr)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
	vim.keymap.set("n", "<leader>ch", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Documentation" })
	vim.keymap.set("n", "<leader>cx", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line Diagnostics" })
	vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { buffer = bufnr, desc = "Lsp Info" })
	vim.keymap.set(
		"n",
		"<leader>cd",
		"<cmd>Telescope lsp_definitions<cr>",
		{ buffer = bufnr, desc = "Find Definitions" }
	)
	vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto Declaration" })
	vim.keymap.set("n", "<leader>cr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr, desc = "Find References" })
	vim.keymap.set(
		"n",
		"<leader>ci",
		"<cmd>Telescope lsp_implementations<cr>",
		{ buffer = bufnr, desc = "Find Implementation" }
	)
	vim.keymap.set(
		"n",
		"<leader>ct",
		"<cmd>Telescope lsp_type_definitions<cr>",
		{ buffer = bufnr, desc = "Find Type Definition" }
	)
	vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
	vim.keymap.set(
		"n",
		"<leader>cs",
		"<cmd>Telescope lsp_document_symbols<cr>",
		{ buffer = bufnr, desc = "Find symbols (document)" }
	)
	vim.keymap.set(
		"n",
		"<leader>cS",
		"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		{ buffer = bufnr, desc = "Find symbols (workspace)" }
	)
	vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = bufnr, desc = "Format buffer with LSP" })
end)

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["lua_ls"] = { "lua" },
		["rust_analyzer"] = { "rust" },
		["null-ls"] = { "python" },
	},
})

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
-- require("lspconfig").pyright.setup()

lsp.setup()

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	sources = {
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
	mapping = {
		["<Tab>"] = cmp_action.luasnip_supertab(),
		["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
	},
})

require("null-ls").setup()
require("mason-null-ls").setup({
	ensure_installed = { "black", "isort" },
	automatic_installation = true,
	automatic_setup = true,
})
require("mason-null-ls").setup_handlers()

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

require("lazy").setup({
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
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "zbirenbaum/copilot.lua" },
			{ "zbirenbaum/copilot-cmp" },
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "jay-babu/mason-null-ls.nvim" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
	{
		"echasnovski/mini.nvim",
	},
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
				["<leader>s"] = { name = "+search (telescope)" },
				["<leader><Tab>"] = { name = "+tabs" },
			}
			wk.register(keymaps)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				map("n", "]h", gs.next_hunk, "Next Hunk")
				map("n", "[h", gs.prev_hunk, "Prev Hunk")
				map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>gd", gs.diffthis, "Diff This")
			end,
		},
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{
				"<leader>x",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "Document Diagnostics (trouble)",
			},
			{
				"<leader>X",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "Workspace Diagnostics (trouble)",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		keys = {
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
			{ "<leader>t", "<cmd>TodoTrouble<cr>", desc = "TODO Comments (trouble)" },
		},
	},
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			char = "│",
			filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
		keys = {
			{
				"<leader>r",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		keys = {
			-- commonly used ones get mappings in the top-level namespace: <leader>...
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>.", "<cmd>Telescope live_grep<cr>", desc = "Find in Files (Grep)" },
			{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Buffer (Fuzzy)" },
			{ "<leader><space>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files" },
			{ "<leader>;", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
			-- +s namespace is for less used commands
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>sQ", "<cmd>Telescope quickfixhistory<cr>", desc = "Quickfix History" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sx", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
			{ "<leader>sh", "<cmd>Telescope pickers<cr>", desc = "Search History" },
			{ "<leader>sH", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jump list" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word" },
			-- these go under the +g namespace because they are closer in spirit to the git commands
			{ "<leader>gf", "<cmd>Telescope git_bcommits<cr>", desc = "Commit History (file)" },
			{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commit History (project)" },
			{ "<leader>gs", "<cmd>Telescope git_stash<cr>", desc = "Stash" },
		},
		opts = {
			defaults = {
				-- cache the last 50 searches
				cache_picker = { num_pickers = 50 },
				file_ignore_patterns = { ".git" },
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
				prompt_prefix = "> ",
				selection_caret = "-> ",
				initial_mode = "insert",
				mappings = {
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
		},
	},
}, {})

-- Treesitter is for syntax highlighting and smart text objects
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"json",
		"lua",
		"luap",
		"markdown",
		"markdown_inline",
		"python",
		"rust",
		"vim",
		"vimdoc",
		"yaml",
	},
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
	-- NB: see the config for mini.ai to see where we define the textobjects
	textobjects = {
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]f"] = "@function.outr",
				["]c"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]F"] = "@function.outer",
				["]C"] = "@class.outer",
				["]A"] = "@parameter.inner",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[F"] = "@function.outer",
				["[C"] = "@class.outer",
				["[A"] = "@parameter.inner",
			},
		},
	},
})

-- Improved editing experience

require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.move").setup()

local spec_treesitter = require("mini.ai").gen_spec.treesitter
require("mini.ai").setup({
	search_method = "cover_or_nearest",
	-- use treesitter for advanced text objects
	custom_textobjects = {
		c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
		m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
		f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
		a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
		o = spec_treesitter({
			a = { "@conditional.outer", "@loop.outer" },
			i = { "@conditional.inner", "@loop.inner" },
		}),
	},
})

require("mini.indentscope").setup({
	symbol = "│",
	draw = { delay = 10 },
	options = { try_as_border = true },
})

require("mini.files").setup({
	mappings = {
		go_in_plus = "<cr>",
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "Open File View" })

require("mini.jump").setup({
	highlight = 1,
})
-- change default highlighting (underline) to something more visible
vim.api.nvim_set_hl(0, "MiniJump", {
	fg = vim.g.terminal_color_0,
	bg = vim.g.terminal_color_10,
})

-- LSP stuff
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

lsp.on_attach(function(_, bufnr)
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

-- this is only for 'real' lsp servers, null-ls is below
-- NB: I prefer to keep this list minimal (only servers I use a lot)
-- I prefer to configure others with mason in the ui
lsp.ensure_installed({
	"pyright",
	"rust_analyzer",
	"dockerls",
	"lua_ls",
	"yamlls",
	"jsonls",
})

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		-- it's generally best to use standalone formatters through null-ls
		-- as opposed to language server builtin formatting, which is usually
		-- not as good. Rust is an exception because rust-analyzer uses rustfmt
		-- by default.
		["rust_analyzer"] = { "rust" },
		["null-ls"] = { "python", "json", "yaml", "lua", "markdown" },
	},
})

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
lsp.configure("yamlls", {
	settings = {
		yaml = { keyOrdering = false },
	},
})

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
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp_action.luasnip_supertab(),
		["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

require("null-ls").setup()
require("mason-null-ls").setup({
	-- again, keep this minimal, servers here cannot be uninstall with the mason ui
	ensure_installed = { "black", "isort", "prettier", "stylua" },
	automatic_installation = true,
	automatic_setup = true,
	handlers = {},
})

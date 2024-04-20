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

if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- KEYMAPS (non plugin specific)
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("t", "<C-h>", "<cmd>wincmd h<CR>")
map("t", "<C-j>", "<cmd>wincmd j<CR>")
map("t", "<C-k>", "<cmd>wincmd k<CR>")
map("t", "<C-l>", "<cmd>wincmd l<CR>")

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- C-Backspace for deleting word in insert mode (equivalent to C-w)
map("i", "<C-H>", "<C-W>", { desc = "Delete last word" })

-- move cursor with alt-hjkl in insert mode
map("c", "<M-h>", "<Left>", { silent = false, desc = "Left" })
map("c", "<M-l>", "<Right>", { silent = false, desc = "Right" })
map("i", "<M-h>", "<Left>", { noremap = false, desc = "Left" })
map("i", "<M-j>", "<Down>", { noremap = false, desc = "Down" })
map("i", "<M-k>", "<Up>", { noremap = false, desc = "Up" })
map("i", "<M-l>", "<Right>", { noremap = false, desc = "Right" })
map("t", "<M-h>", "<Left>", { desc = "Left" })
map("t", "<M-j>", "<Down>", { desc = "Down" })
map("t", "<M-k>", "<Up>", { desc = "Up" })
map("t", "<M-l>", "<Right>", { desc = "Right" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Don't move cursor when searching for current word
-- NB this makes # and * do basically the same thing
map("n", "*", "*``", { desc = "Search for current word" })
map("n", "#", "#``", { desc = "Search for current word" })

-- Quicker find and replace with confirmation (nb the visual mode one overrides h register)
map("v", "<leader>#", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "Find and replace selected text" })
map("n", "<leader>#", ":%s/<C-r><C-w>//gc<Left><Left><left>", { desc = "Find and replace current word" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy (plugin manager)" })

-- new file
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })

-- quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>tq", "<cmd>tabclose<cr>", { desc = "Quit Tab" })
map("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- toggle word wrap
map("n", "<leader>w", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })

-- d,c,x delete to 'd', 'c', 'x' registers by default for a better copy paste experience
-- Now we can copy-delete-paste without losing the first copy
-- To paste from the delete registers use "dp, "cp, "xp
-- The default delete registers of " and - still work as expected
map("n", "d", '"dd')
map("v", "d", '"dd')
map("n", "D", '"dD')
map("v", "D", '"dD')

map("n", "x", '"xx')
map("v", "x", '"xx')
map("n", "X", '"xX')
map("v", "X", '"xX')

map("n", "c", '"cc')
map("v", "c", '"cc')
map("n", "C", '"cC')
map("v", "C", '"cC')

-- AUTOCOMMANDS
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- resize splits if window got resized
local resize_splits_group = vim.api.nvim_create_augroup("ResizeSplits", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = resize_splits_group,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- go to last loc when opening a buffer
local last_loc_group = vim.api.nvim_create_augroup("LastLoc", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_loc_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- set formatoptions for all filetypes -- default is "jcroql"
local formatoptions_group = vim.api.nvim_create_augroup("Formatoptions", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = formatoptions_group,
	callback = function()
		vim.opt_local.formatoptions = "tcqjr"
	end,
	pattern = "*",
})

-- use absoulute line numbers in insert mode and when buffer is not in focus
local line_numbers_group = vim.api.nvim_create_augroup("LineNumbers", { clear = true })
vim.api.nvim_create_autocmd({ "InsertEnter", "FocusLost", "WinLeave" }, {
	group = line_numbers_group,
	callback = function()
		if vim.opt_local.number:get() then
			vim.opt_local.relativenumber = false
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusGained", "WinEnter" }, {
	group = line_numbers_group,
	callback = function()
		if vim.opt_local.number:get() then
			vim.opt_local.relativenumber = true
		end
	end,
})

-- scrolloff at end of file (based on Aasim-A/scrollEOF.nvim)
local function check_eof_scrolloff()
	local win_height = vim.api.nvim_win_get_height(0)
	local win_view = vim.fn.winsaveview()
	local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
	local scrolloff_line_count = win_height - (vim.fn.line("w$") - win_view.topline + 1)
	local distance_to_last_line = vim.fn.line("$") - win_view.lnum

	if distance_to_last_line < scrolloff and scrolloff_line_count + distance_to_last_line < scrolloff then
		win_view.topline = win_view.topline + scrolloff - (scrolloff_line_count + distance_to_last_line)
		vim.fn.winrestview(win_view)
	end
end

local scrollEOF_group = vim.api.nvim_create_augroup("ScrollEOF", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
	group = scrollEOF_group,
	pattern = "*",
	callback = check_eof_scrolloff,
})

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
				["<leader>s"] = { name = "+search (telescope)" },
				["<leader>x"] = { name = "+diagnostics (trouble)" },
				["<leader>t"] = { name = "+tabs" },
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

				-- this is under the x namespace because it uses the quickfix list and trouble
				map("n", "<leader>xg", "<cmd>Gitsigns setqflist<cr>", { desc = "Git hunks" })
			end,
		},
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true, auto_preview = false },
		keys = {
			{
				"<leader>xb",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "Buffer diagnostics",
			},
			{
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "Workspace diagnostics",
			},
			{
				"<leader>xq",
				"<cmd>TroubleToggle quickfix<cr>",
				desc = "Quickfix list",
			},
			{
				"<leader>xl",
				"<cmd>TroubleToggle location<cr>",
				desc = "Location list",
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
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo" },
		},
	},
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
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
			{ "<leader>gh", "<cmd>Telescope git_bcommits<cr>", desc = "File history (telescope)" },
			{ "<leader>gH", "<cmd>Telescope git_commits<cr>", desc = "Project history (telescope)" },
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
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
				["]]"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]F"] = "@function.outer",
				["]C"] = "@class.outer",
				["]["] = "@class.outer",
				["]A"] = "@parameter.inner",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
				["[["] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[F"] = "@function.outer",
				["[C"] = "@class.outer",
				["[]"] = "@class.outer",
				["[A"] = "@parameter.inner",
			},
		},
	},
})

-- Improved editing experience
require("mini.comment").setup()
require("mini.move").setup()
require("mini.surround").setup()

require("mini.statusline").setup()

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
	draw = { delay = 0 },
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

-- LSP stuff
require("mason").setup({
	ui = {
		border = "rounded",
	},
})
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason (LSP GUI)" })

require("copilot").setup({
	-- disable suggestion because we use nvim cmp
	-- NB you can bring up a panel with alt-enter in insert mode
	suggestion = { enabled = false },
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

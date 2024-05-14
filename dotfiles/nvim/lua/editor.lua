-- Plugins for improving the editor experience

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- which-key provides hints/menus to visualise keybindings
require("which-key").setup()
require("which-key").register({
	mode = { "n", "v" },
	["g"] = { name = "+goto" },
	["]"] = { name = "+next" },
	["["] = { name = "+prev" },
	["<leader>c"] = { name = "+code" },
	["<leader>g"] = { name = "+git" },
	["<leader>s"] = { name = "+search (mini.Pick)" },
})

-- trouble is an improved quickfix/location list for showing diagnostics
require("trouble").setup({ use_diagnostic_signs = true, auto_preview = false, padding = false })
map(
	"n",
	"<leader>d",
	"<cmd>TroubleToggle document_diagnostics<cr><cmd>wincmd p<cr>",
	{ desc = "[d]iagnostics (buffer)" }
)
map(
	"n",
	"<leader>D",
	"<cmd>TroubleToggle workspace_diagnostics<cr><cmd>wincmd p<cr>",
	{ desc = "[D]iagnostics (workspace)" }
)

-- treesitter is for syntax highlighting and smart text objects
require("nvim-treesitter.configs").setup({
	ensure_installed = { "bash", "json", "lua", "markdown", "python", "rust", "vim", "vimdoc", "yaml" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
		},
	},
})

-- mini.nvim is a set of small utilities for improving the editor
require("mini.bracketed").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.move").setup()
require("mini.surround").setup()
require("mini.statusline").setup()
require("mini.jump").setup()
require("mini.extra").setup()

require("mini.files").setup({
	mappings = {
		go_in_plus = "<cr>",
	},
})
map("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "[e]xplorer (mini.Files)" })

local spec_treesitter = require("mini.ai").gen_spec.treesitter
require("mini.ai").setup({
	-- use treesitter for advanced text objects
	custom_textobjects = {
		c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
		m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
		f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
		a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
	},
})

require("mini.indentscope").setup({
	symbol = "│",
	draw = { delay = 10, animation = require("mini.indentscope").gen_animation.none() },
	options = { try_as_border = true },
})

require("mini.pick").setup({
	mappings = {
		move_down = "<C-j>",
		move_up = "<C-k>",
		paste = "<C-p>",
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
	},

	-- Window related options
	window = {
		-- Float window config (table or callable returning it)
		config = { width = 1000, height = 15 },
	},
})

-- commonly used search keymaps in top level namespace
map("n", "<leader><space>", "<cmd>Pick files<cr>", { desc = "Search files" })
map("n", "<leader>,", "<cmd>Pick buffers<cr>", { desc = "Search buffers" })
map("n", "<leader>;", "<cmd>Pick resume<cr>", { desc = "Resume last search" })
map("n", "<leader>.", "<cmd>Pick grep_live<cr>", { desc = "Live grep (workspace)" })
map("n", "<leader>/", '<cmd>Pick buf_lines scope="current"<cr>', { desc = "Fuzzy search (buffer)" })

-- <leader>s namespace is for searching with fuzzy finder (mini.pick)
map("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "[h]elp pages" })
map("n", "<leader>sf", "<cmd>Pick explorer<cr>", { desc = "[f]iles (tree view)" })
map("n", "<leader>s/", '<Cmd>Pick history scope="/"<CR>', { desc = "[/] search history" })
map("n", "<leader>s:", '<Cmd>Pick history scope=":"<CR>', { desc = "[:] command history" })
map("n", "<leader>sc", '<Cmd>Pick git_commits path="%"<CR>', { desc = "[c]ommits (file)" })
map("n", "<leader>sC", "<Cmd>Pick git_commits<CR>", { desc = "[C]ommits (workspace)" })
map("n", "<leader>sd", '<Cmd>Pick diagnostic scope="current"<CR>', { desc = "[d]iagnostics (file)" })
map("n", "<leader>sD", '<Cmd>Pick diagnostic scope="all"<CR>', { desc = "[D]iagnostics (workspace)" })
map("n", "<leader>sr", '<cmd>Pick lsp scope="references"<cr>', { desc = "[r]eferences" })
map("n", "<leader>ss", '<cmd>Pick lsp scope="document_symbol"<cr>', { desc = "[s]ymbol (file)" })
map("n", "<leader>sS", '<cmd>Pick lsp scope="workspace_symbol"<cr>', { desc = "[S]ymbol (workspace)" })
map("n", "<leader>sq", '<cmd>Pick list scope="quickfix"<cr>', { desc = "[q]uickfix list" })
map("n", "<leader>sl", '<cmd>Pick list scope="location"<cr>', { desc = "[l]ocation list" })
map("n", "<leader>sj", '<cmd>Pick list scope="jump"<cr>', { desc = "[j]ump list" })

require("gitsigns").setup({
	signcolumn = false,
	numhl = true,
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
	end,
})

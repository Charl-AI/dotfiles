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
	},
})

require("mini.indentscope").setup({
	symbol = "│",
	draw = { delay = 0 },
	options = { try_as_border = true },
})

require("mini.extra").setup()
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

-- commonly used keymaps in top level namespace
vim.keymap.set("n", "<leader><space>", "<cmd>Pick files<cr>", { desc = "Search files" })
vim.keymap.set("n", "<leader>,", "<cmd>Pick buffers<cr>", { desc = "Search buffers" })
vim.keymap.set("n", "<leader>;", "<cmd>Pick resume<cr>", { desc = "Resume last search" })
vim.keymap.set("n", "<leader>.", "<cmd>Pick grep_live<cr>", { desc = "Live grep (workspace)" })
vim.keymap.set("n", "<leader>/", '<cmd>Pick buf_lines scope="current"<cr>', { desc = "Fuzzy search (buffer)" })

-- s is for searching with fuzzy finder (mini.pick)
vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "[h]elp pages" })
vim.keymap.set("n", "<leader>sf", "<cmd>Pick explorer<cr>", { desc = "[f]iles (tree view)" })
vim.keymap.set("n", "<leader>s/", '<Cmd>Pick history scope="/"<CR>', { desc = "[/] search history" })
vim.keymap.set("n", "<leader>s:", '<Cmd>Pick history scope=":"<CR>', { desc = "[:] command history" })
vim.keymap.set("n", "<leader>sc", '<Cmd>Pick git_commits path="%"<CR>', { desc = "[c]ommits (file)" })
vim.keymap.set("n", "<leader>sC", "<Cmd>Pick git_commits<CR>", { desc = "[C]ommits (workspace)" })
vim.keymap.set("n", "<leader>sd", '<Cmd>Pick diagnostic scope="current"<CR>', { desc = "[d]iagnostics (file)" })
vim.keymap.set("n", "<leader>sD", '<Cmd>Pick diagnostic scope="all"<CR>', { desc = "[D]iagnostics (workspace)" })
vim.keymap.set("n", "<leader>sr", '<cmd>Pick lsp scope="references"<cr>', { desc = "[r]eferences" })
vim.keymap.set("n", "<leader>ss", '<cmd>Pick lsp scope="document_symbol"<cr>', { desc = "[s]ymbol (file)" })
vim.keymap.set("n", "<leader>sS", '<cmd>Pick lsp scope="workspace_symbol"<cr>', { desc = "[S]ymbol (workspace)" })
vim.keymap.set("n", "<leader>sq", '<cmd>Pick list scope="quickfix"<cr>', { desc = "[q]uickfix list" })
vim.keymap.set("n", "<leader>sl", '<cmd>Pick list scope="location"<cr>', { desc = "[l]ocation list" })
vim.keymap.set("n", "<leader>sj", '<cmd>Pick list scope="jump"<cr>', { desc = "[j]ump list" })
-- vim.keymap.set("n", "<leader>sd", '<cmd>Pick lsp scope="definition"<cr>', { desc = "[d]efinition" })

require("mini.files").setup({
	mappings = {
		go_in_plus = "<cr>",
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "[e]xplorer (mini.Files)" })

require("mini.jump").setup({
	highlight = 1,
})

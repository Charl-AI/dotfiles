return {

	-- misc plugins for better experience
	{ "tpope/vim-sleuth" },
	{
		"christoomey/vim-tmux-navigator",
		event = { "BufReadPost", "BufNewFile" },
	},

	-- multi-cursor with C-n
	{
		"mg979/vim-visual-multi",
		init = function()
			-- equivalent to let g:VM_default_mappings = 0
			vim.g.VM_default_mappings = 0
		end,
	},

	-- fuzzy finder
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
				prompt_prefix = " ",
				selection_caret = " ",
				initial_mode = "insert",
				mappings = {
					i = {
						["<C-j>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-k>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
		},
	},

	-- which-key
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

	-- git signs
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

	-- Lots of useful stuff here
	{
		"echasnovski/mini.nvim",
		-- as of 06/08/23, stable version (*) does not include mini.files
		-- version = "*",
		config = function()
			require("mini.surround").setup()
			require("mini.ai").setup()
			require("mini.pairs").setup()
			require("mini.comment").setup()
			require("mini.move").setup()
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

			require("mini.jump").setup({
				highlight = 1,
			})
			-- change default highlighting (underline) to something more visible
			vim.api.nvim_set_hl(0, "MiniJump", {
				fg = vim.g.terminal_color_0,
				bg = vim.g.terminal_color_10,
			})
		end,
		keys = {
			{ "<leader>e", "<cmd>lua MiniFiles.open()<cr>", desc = "Open File View" },
		},
	},

	-- better diagnostics list and others
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
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						vim.cmd.cprev()
					end
				end,
				desc = "Previous trouble/quickfix item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						vim.cmd.cnext()
					end
				end,
				desc = "Next trouble/quickfix item",
			},
		},
	},

	-- todo comments
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		-- stylua: ignore
		keys = {
			{ "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
			{
				"[t",
				function() require("todo-comments").jump_prev() end,
				desc =
				"Previous todo comment"
			},
			{ "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
			{ "<leader>t", "<cmd>TodoTrouble<cr>", desc="TODO Comments (trouble)"}
		},
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}

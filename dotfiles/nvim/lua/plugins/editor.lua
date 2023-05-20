return {

	-- misc plugins for better experience
	{ "tpope/vim-sleuth" },
	{
		"Aasim-A/scrollEOF.nvim",
		config = function()
			require("scrollEOF").setup()
		end,
	},
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

	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		keys = {
			-- commonly used ones have additional mappings with <leader>...
			{ "<leader>,",       "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>?",       "<cmd>Telescope live_grep<cr>",                     desc = "Find in Files (Grep)" },
			{ "<leader>/",       "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Find in Buffer (Grep)" },
			{ "<leader><space>", "<cmd>Telescope find_files hidden=true<cr>",        desc = "Find Files" },
			-- +s namespace is for complete list of telescope commands
			{ "<leader>sa",      "<cmd>Telescope autocommands<cr>",                  desc = "Auto Commands" },
			{ "<leader>sb",      "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Buffers" },
			{ "<leader>sc",      "<cmd>Telescope command_history<cr>",               desc = "Command History" },
			{ "<leader>sC",      "<cmd>Telescope commands<cr>",                      desc = "Commands" },
			{ "<leader>sx",      "<cmd>Telescope diagnostics<cr>",                   desc = "Diagnostics" },
			{ "<leader>sg",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Grep (buffer)" },
			{ "<leader>sG",      "<cmd>Telescope live_grep<cr>",                     desc = "Grep (all files)" },
			{ "<leader>sh",      "<cmd>Telescope help_tags<cr>",                     desc = "Help Pages" },
			{ "<leader>sj",      "<cmd>Telescope jumplist<cr>",                      desc = "Jump list" },
			{ "<leader>sk",      "<cmd>Telescope keymaps<cr>",                       desc = "Key Maps" },
			{ "<leader>sM",      "<cmd>Telescope man_pages<cr>",                     desc = "Man Pages" },
			{ "<leader>sm",      "<cmd>Telescope marks<cr>",                         desc = "Jump to Mark" },
			{ "<leader>so",      "<cmd>Telescope vim_options<cr>",                   desc = "Options" },
			{ "<leader>sw",      "<cmd>Telescope grep_string<cr>",                   desc = "Word" },
		},
		opts = {
			defaults = {
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

	-- clipboard manager
	{
		"AckslD/nvim-neoclip.lua",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("neoclip").setup({
				default_register = { '"', "+", "*" },
			})
			require("telescope").load_extension("neoclip")
		end,
		keys = {
			{ "<leader>p",  "<cmd>Telescope neoclip<cr>", desc = "Clipboard History" },
			{ "<leader>sp", "<cmd>Telescope neoclip<cr>", desc = "Clipboard" },
		},
	},

	-- easily jump to any location and enhanced f/t motions for Leap
	{
		"ggandor/flit.nvim",
		keys = function()
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s",  mode = { "n", "x", "o" }, desc = "Leap (bidirectional)" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap (other windows)" },
		},
		opts = {
			-- just the default labels, minus capital letters
			labels = {
				"s",
				"f",
				"n",
				"j",
				"k",
				"l",
				"h",
				"o",
				"d",
				"w",
				"e",
				"m",
				"b",
				"u",
				"y",
				"v",
				"r",
				"g",
				"t",
				"c",
				"x",
				"/",
				"z",
			},
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.set({ "n", "x", "o" }, "s", function()
				local current_window = vim.fn.win_getid()
				require("leap").leap({ target_windows = { current_window } })
			end)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
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

	-- references
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = { delay = 50 },
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	-- paired brackets
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_)
			require("mini.pairs").setup()
		end,
	},

	-- comment in/out text
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function(_)
			require("mini.comment").setup()
		end,
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
		},
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}

return {

	-- Theme inspired by Atom
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			-- char = "▏",
			char = "│",
			filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},

	-- active indent guide and indent text objects
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			draw = { delay = 10 },
			options = { try_as_border = true },
		},
		config = function(_, opts)
			require("mini.indentscope").setup(opts)
		end,
	},

	-- Set lualine as statusline
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

	-- dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " [f]ind file", ":Telescope find_files hidden=true<CR>"),
				dashboard.button("n", " " .. " [n]ew file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", " " .. " [r]ecent files", ":Telescope oldfiles <CR>"),
				dashboard.button("g", " " .. " [g]rep text", ":Telescope live_grep <CR>"),
				dashboard.button("c", " " .. " [c]onfig", ":e $MYVIMRC <CR>"),
				dashboard.button("s", " " .. " [s]ession restore", [[:lua require("persistence").load() <cr>]]),
				dashboard.button("l", "󰒲 " .. " [l]azy menu", ":Lazy<CR>"),
				dashboard.button("q", " " .. " [q]uit", ":qa<CR>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},

	-- ui components (needed for neotree)
	{ "MunifTanjim/nui.nvim",        lazy = true },

	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- session management
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
}

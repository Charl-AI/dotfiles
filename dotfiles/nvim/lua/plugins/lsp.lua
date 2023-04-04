return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		keys = {
			{ "K", vim.lsp.buf.hover, desc = "Hover" },
			{ "<leader>ch", vim.lsp.buf.signature_help, desc = "Signature Documentation" },
			{ "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
			{ "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
			{ "<leader>cd", "<cmd>Telescope lsp_definitions<cr>", desc = "Find Definitions" },
			{ "<leader>cD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
			{ "<leader>cr", "<cmd>Telescope lsp_references<cr>", desc = "Find References" },
			{ "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Find Implementation" },
			{ "<leader>ct", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Find Type Definition" },
			{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
			{ "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbols (document)" },
			{ "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Find symbols (workspace)" },
			{ "<leader>cf", vim.lsp.buf.format, desc = "Format buffer with LSP" },
		},
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Open Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local servers = {
				-- NB this table uses different names for the servers than mason
				-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
				-- if you want to use the mason names you can use the table in mason-null=ls.nvim
				"jsonls",
				"yamlls",
			}
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			})
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		config = function()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			require("null-ls").setup({
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 5000 })
							end,
						})
					end
				end,
			})
		end,
	},

	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"dockerfile-language-server",
					"shfmt",
					"black",
					"isort",
					"lua-language-server",
					"pyright",
				},
				automatic_installation = true,
				automatic_setup = true,
			})
			require("mason-null-ls").setup_handlers()
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					-- we map tab as accept later in cmp to prevent clashing
					accept = false,
					accept_word = "<C-l>",
					-- commented out to avoid clashes with cmp
					-- accept_line = "<C-j>",
					dismiss = "<C-e>",
					next = "<C-n>",
					previous = "<C-p>",
				},
			},
			panel = {
				enabled = true,
				keymap = {
					open = "<C-p>",
				},
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
		},
		opts = function()
			local cmp = require("cmp")
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					-- remove c-p default mapping
					["<C-p>"] = cmp.mapping(function(fallback)
						fallback()
					end, { "i", "s" }),
					-- remove c-n default mapping
					["<C-n>"] = cmp.mapping(function(fallback)
						fallback()
					end, { "i", "s" }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").accept()
						elseif cmp.visible() then
							cmp.confirm()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},
}

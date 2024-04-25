local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local default_setup = function(server)
	require("lspconfig")[server].setup({
		capabilities = lsp_capabilities,
	})
end

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
	handlers = {
		default_setup,

		-- lua_ls custom setup to work with neovim config
		lua_ls = function()
			require("lspconfig").lua_ls.setup({
				capabilities = lsp_capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					},
				},
			})
		end,
	},
})
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "[m]ason (LSP installer)" })
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },

		-- use ruff if available, else isort and black
		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_fix", "ruff_format" }
			else
				return { "isort", "black" }
			end
		end,
	},
	format_on_save = function(_)
		if vim.g.disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_fallback = true }
	end,
})

vim.api.nvim_create_user_command("FormatToggle", function()
	if vim.g.disable_autoformat == true then
		vim.g.disable_autoformat = false
		print("Enabling autoformat-on-save")
	else
		vim.g.disable_autoformat = true
		print("Disabling autoformat-on-save")
	end
end, {
	desc = "Toggle autoformat-on-save",
})

-- ruff fix tries to fix errors by default,
-- I just want it to sort imports
-- (NB we can let ruff_format do the rest of the formatting)
require("conform").formatters.ruff_fix = {
	prepend_args = { "--select=I" },
}

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local cmp = require("cmp")
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	sources = {
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),

		["<Tab>"] = function(fallback)
			if not cmp.select_next_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,

		["<S-Tab>"] = function(fallback)
			if not cmp.select_prev_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,
	},

	snippet = {
		expand = function(args)
			unpack = unpack or table.unpack
			local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
			local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
			local indent = string.match(line_text, "^%s*")
			local replace = vim.split(args.body, "\n", { true })
			local surround = string.match(line_text, "%S.*") or ""
			local surround_end = surround:sub(col)

			replace[1] = surround:sub(0, col - 1) .. replace[1]
			replace[#replace] = replace[#replace] .. (#surround_end > 1 and " " or "") .. surround_end
			if indent ~= "" then
				for i, line in ipairs(replace) do
					replace[i] = indent .. line
				end
			end

			vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
		end,
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

-- disable virtual text for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
})

-- if there are diagnostics available for a line, show them instead of the hover window
local function hover_or_diagnostic()
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	local diagnostics =
			vim.diagnostic.get(0, { lnum = line_num - 1, severity = { min = vim.diagnostic.severity.HINT } })

	if #diagnostics == 0 then
		vim.lsp.buf.hover()
	else
		vim.diagnostic.open_float()
	end
end
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		vim.keymap.set("n", "K", hover_or_diagnostic, { buffer = event.buf, desc = "Hover" })
		vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { buffer = event.buf, desc = "[l]sp info" })
		vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { buffer = event.buf, desc = "[h]over" })
		vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { buffer = event.buf, desc = "[R]ename" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "[a]ction" })
		vim.keymap.set(
			"n",
			"<leader>cc",
			"<cmd>ConformInfo<cr>",
			{ buffer = event.buf, desc = "[c]onform (formatter) info" }
		)
		vim.keymap.set(
			"n",
			"<leader>cf",
			"<cmd>FormatToggle<cr>",
			{ buffer = event.buf, desc = "[f]ormat on save (toggle)" }
		)

		-- the built in LSP uses the quickfix list for these methods, here we use trouble because I think it is a bit nicer
		vim.keymap.set(
			"n",
			"<leader>cd",
			"<cmd>Trouble lsp_definitions<cr>",
			{ buffer = event.buf, desc = "[d]efinitions" }
		)
		vim.keymap.set(
			"n",
			"<leader>cr",
			"<cmd>Trouble lsp_references<cr>",
			{ buffer = event.buf, desc = "[r]eferences" }
		)
		vim.keymap.set(
			"n",
			"<leader>ci",
			"<cmd>Trouble lsp_implementations<cr>",
			{ buffer = event.buf, desc = "[i]mplementations" }
		)
		vim.keymap.set(
			"n",
			"<leader>ct",
			"<cmd>Trouble lsp_type_definitions<cr>",
			{ buffer = event.buf, desc = "[t]ype definitions" }
		)
	end,
})

-- LSP plugins

-- mason is for installing language servers
require("mason").setup()
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "[m]ason (LSP installer)" })

vim.lsp.config("luals", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = { vim.env.VIMRUNTIME } },
    },
  },
})
vim.lsp.enable("luals")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    sh = { "shfmt" },
    markdown = { "prettier" },
    bib = { "bibtex-tidy" },

    -- use ruff if available, else isort and black
    python = function(bufnr)
      local formatters = {}
      if require("conform").get_formatter_info("ruff_organize_imports", bufnr).available then
        table.insert(formatters, "ruff_organize_imports")
      else
        table.insert(formatters, "isort")
      end
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        table.insert(formatters, "ruff_format")
      else
        table.insert(formatters, "black")
      end
      return formatters
    end,

    -- "_" is for filetypes without any other formatters
    ["_"] = {
      "trim_whitespace",
      "trim_newlines",
    },
  },
  format_on_save = function(_)
    if vim.g.disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
})

require("conform").formatters.shfmt = {
  prepend_args = { "--indent=2", "--case-indent" },
}

require("conform").formatters.stylua = {
  prepend_args = { "--indent-type=Spaces", "--indent-width=2" },
}
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

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("blink.cmp").setup({
  keymap = { preset = "default" },
  cmdline = { completion = { menu = { auto_show = true } } },
  completion = { list = { selection = { preselect = false, auto_insert = true } } },
  fuzzy = { implementation = "prefer_rust" },
  signature = { enabled = true },
})

vim.diagnostic.config({ virtual_text = false, severity_sort = true })

-- if there are diagnostics available for a line, this function toggles
-- between the hover window and diagnostic window. Note that when it is
-- mapped to K it prevents us from entering the window by pressing K again
-- (because it will toggle instead)
vim.g.replace_hover_with_diagnostics = true
vim.api.nvim_create_autocmd("CursorMoved", {
  desc = "Reset hover diagnostic toggle",
  callback = function()
    vim.g.replace_hover_with_diagnostics = true
  end,
})

local function hover_or_diagnostic()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local diagnostics = vim.diagnostic.get(0, { lnum = line_num - 1, severity = { min = vim.diagnostic.severity.HINT } })

  -- use default hover behaviour if no diagnostics are available
  if #diagnostics == 0 then
    vim.lsp.buf.hover()
    return
  end

  if vim.g.replace_hover_with_diagnostics == true then
    vim.diagnostic.open_float({ source = true })
    vim.g.replace_hover_with_diagnostics = false
  else
    vim.lsp.buf.hover()
    vim.g.replace_hover_with_diagnostics = true
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    vim.keymap.set("n", "K", hover_or_diagnostic, { buffer = event.buf, desc = "Hover" })
    vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { buffer = event.buf, desc = "[l]sp info" })
    vim.keymap.set("n", "<leader>ck", vim.lsp.buf.hover, { buffer = event.buf, desc = "[k] hover" })
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { buffer = event.buf, desc = "[R]ename" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "[a]ction" })
    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { buffer = event.buf, desc = "[d]efinitions" })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { buffer = event.buf, desc = "[r]eferences" })
    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, { buffer = event.buf, desc = "[i]mplementations" })
    vim.keymap.set("n", "<leader>ct", vim.lsp.buf.type_definition, { buffer = event.buf, desc = "[t]ype definitions" })
    vim.keymap.set("n", "<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
    end, { desc = "[h]ints (toggle inlay)" })
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
  end,
})

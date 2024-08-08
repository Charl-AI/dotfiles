-- llpp (loclist plus plus) is a custom loclist that opens in
-- the current window instead of a split. The idea is to treat the list as an
-- 'alternate view' of the buffer to help with navigation.
-- See Oil.nvim or [1] for why I like this workflow.
-- [1] http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/

---@class Item
---@field bufnr number
---@field lnum number
---@field col number
---@field type string
---@field text string

---@alias window number

---@type table<window, Item[]>
local diagnostics_cache = {}

---@type table<window, Item[]>
local symbols_cache = {}

---@param cache table<window, Item[]>
local function open_llpp(cache)
  local win = vim.api.nvim_get_current_win()
  local items = cache[win]

  vim.api.nvim_command("enew")
  vim.bo.buftype = "nofile"
  vim.bo.filetype = "llpp"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "loclist (llpp)" })

  -- effectively allows us to inherit the syntax highlighting from the qf
  -- filetype, whilst keeping our custom mappings only for our llpp type
  vim.api.nvim_exec2("setlocal filetype=qf", {})

  -- Populate the buffer with the items
  for _, item in ipairs(items) do
    if item.type == nil then
      item.type = ""
    end
    local line =
      string.format("%s|%4d:%-3d %s| %s", vim.fn.bufname(item.bufnr), item.lnum, item.col, item.type, item.text)
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { line })
  end
end

-- go to the location under cursor. Assumes that the line has been formatted:
-- filename|lnum:col ...
local function goto_loc()
  local line = vim.fn.getline(".")
  local pattern = "([^|]+)|%s*(%d+):%s*(%d+)%s+[^|]+|%s+.*"
  local filename, lnum, col = string.match(line, pattern)

  if filename and lnum and col then
    -- Open the file and jump to the line and column number
    vim.cmd("edit " .. vim.fn.fnamemodify(filename, ":p"))
    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) })
  end -- local col = item.col

  if filename and lnum and col then
    vim.cmd("edit " .. vim.fn.fnamemodify(filename, ":p"))
    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) })
  end
end

local function update_diagnostics_cache()
  local win = vim.api.nvim_get_current_win()
  local diagnostics = vim.diagnostic.get(0)
  diagnostics_cache[win] = vim.diagnostic.toqflist(diagnostics)
end

local function update_symbols_cache()
  -- first check to see if there is a valid lsp client attached
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ method = "textDocument/documentSymbol", bufnr = buf })
  local valid_clients = vim.tbl_filter(function(client)
    return client.supports_method("textDocument/documentSymbol")
  end, clients)
  if #valid_clients == 0 then
    return
  end

  local win = vim.api.nvim_get_current_win()
  local allowed_symbols = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  }

  vim.lsp.buf.document_symbol({
    on_list = function(options)
      local filtered_items = {}

      for _, item in ipairs(options.items) do
        -- Extract the symbol type from item.text, assuming text is
        -- structured like so: "[Function] function_name"
        local symbol_type = string.match(item.text, "^%[([^%]]+)%]")
        if symbol_type and vim.tbl_contains(allowed_symbols, symbol_type) then
          -- for some reason filename is set by default but not bufnr
          item["bufnr"] = vim.fn.bufnr(item.filename)
          table.insert(filtered_items, item)
        end
      end

      symbols_cache[win] = filtered_items
    end,
  })
end

-- keep llpp diagnostics list updated
vim.api.nvim_create_autocmd({ "BufEnter", "DiagnosticChanged" }, {
  callback = update_diagnostics_cache,
})

-- keep llpp symbols list updated
vim.api.nvim_create_autocmd({ "LspAttach", "TextChanged" }, {
  callback = update_symbols_cache,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    -- set llpp keymaps
    vim.keymap.set("n", "<CR>", goto_loc, { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "q", function()
      vim.cmd("e#")
    end, { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "<leader>o", function()
      vim.cmd("e#")
    end, { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "<leader>d", function()
      vim.cmd("e#")
    end, { noremap = true, silent = true, buffer = true })
  end,
  pattern = "llpp",
})

vim.keymap.set("n", "<leader>d", function()
  open_llpp(diagnostics_cache)
end, { noremap = true, silent = true, desc = "[d]iagnostics (buffer)" })
vim.keymap.set("n", "<leader>o", function()
  open_llpp(symbols_cache)
end, { noremap = true, silent = true, desc = "[o]utline (buffer symbols)" })
vim.keymap.set(
  "n",
  "<leader>D",
  vim.diagnostic.setqflist,
  { noremap = true, silent = true, desc = "[D]iagnostics (workspace)" }
)

-- Options, keymaps, autocmds for nvim (not including plugins)

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.linebreak = true
opt.number = true
opt.pumheight = 10
opt.scrolloff = 2
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help" }
opt.shiftround = true
opt.tabstop = 2
opt.shiftwidth = 0 -- use tabstop value
opt.sidescrolloff = 5
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
opt.wrap = false
opt.fillchars = { eob = " " }
opt.jumpoptions = "view,stack"

-- show tab characters
opt.list = true
opt.listchars:append({
  tab = "<->",
})

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Use Q instead of q for recording macros
map("n", "Q", "q")
map("n", "q", "<Nop>")

-- Move to window using the <ctrl> hjkl keys
map({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- use esc to go to normal mode in terminal
map("t", "<esc>", [[<C-\><C-n>]])

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- C-Backspace for deleting word in insert mode (equivalent to C-w)
map("i", "<C-H>", "<C-W>", { desc = "Delete last word" })

-- move cursor with alt-hjkl in insert mode
map({ "i", "c", "t" }, "<M-h>", "<Left>", { silent = false, noremap = false, desc = "Left" })
map({ "i", "c", "t" }, "<M-j>", "<Down>", { silent = false, noremap = false, desc = "Down" })
map({ "i", "c", "t" }, "<M-k>", "<Up>", { silent = false, noremap = false, desc = "Up" })
map({ "i", "c", "t" }, "<M-l>", "<Right>", { silent = false, noremap = false, desc = "Right" })

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
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- new file
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "[n]ew File" })

-- quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "[q]uit all" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- toggle word wrap
map("n", "<leader>w", "<cmd>set wrap!<cr>", { desc = "[w]ord wrap (toggle)" })

-- I don't like how deleting typically overrides the register with your
-- last copy because it makes it harder to copy-delete-paste.
-- This changes the d,c,x operators to delete to 'd', 'c', 'x' registers by default
-- Now we can copy-delete-paste without losing the first copy
-- To paste from the delete registers use "dp, "cp, "xp
-- The default delete registers of " and - still work as expected
map({ "n", "v" }, "d", '"dd')
map({ "n", "v" }, "D", '"dD')

map({ "n", "v" }, "x", '"xx')
map({ "n", "v" }, "X", '"xX')

map({ "n", "v" }, "c", '"cc')
map({ "n", "v" }, "C", '"cC')

-- search in only the visible screen, respecting the scrolloff setting.
-- The window will never scroll when searching with this function.
local function screen_search()
  local scrolloff = vim.o.scrolloff
  local botline = vim.fn.line("w$") + 1
  local topline = vim.fn.line("w0") - 1
  local eofline = vim.fn.line("$")

  if topline > scrolloff then
    topline = topline + scrolloff
  end

  if botline < eofline - scrolloff then
    botline = botline - scrolloff
  end

  local pattern = "/\\%>" .. topline .. "l\\%<" .. botline .. "l"
  vim.fn.feedkeys(pattern, "n")
end
vim.api.nvim_create_user_command("ScreenSearch", screen_search, { desc = "" })

-- Experimental: mapping ? to my custom screen search function. I don't
-- use ? that much anyway because I use / with wrapping as bidirectional search
map({ "n", "v" }, "?", screen_search, { desc = "" })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- set formatoptions for all filetypes -- default is "jcroql"
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions = "tcqjr"
  end,
  pattern = "*",
})

-- keep quickfix list updated
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist({ open = false, title = "Workspace Diagnostics" })
  end,
})

-- set lisp mode for lisp languages
-- this treats hyphens as part of the word and improves indentation
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.lisp = true
  end,
  pattern = { "*.fnl", "*.lisp", "*.clj", "*.scm", "*.rkt" },
})

-- scrolloff at end of file (based on Aasim-A/scrollEOF.nvim)
local function check_eof_scrolloff()
  if vim.bo.buftype ~= "" then -- exclude all non-standard buffers
    return
  end

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

vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = check_eof_scrolloff,
})

-- session management (based on folke/persistence.nvim)
-- sessions are saved at $HOME/.local/state/sessions/%path%to%project%dir.vim
local function get_session_path()
  local save_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")
  os.execute("mkdir -p " .. save_dir)
  local curr_name = vim.fn.getcwd():gsub("/", "%%")
  local session_path = save_dir .. curr_name .. ".vim"
  return session_path
end

local function save_session()
  -- don't save the session if there are no proper buffers open
  local bufs = vim.tbl_filter(function(b)
    if vim.bo[b].buftype ~= "" then
      return false
    end
    if vim.bo[b].filetype == "gitcommit" then
      return false
    end
    if vim.bo[b].filetype == "gitrebase" then
      return false
    end
    return vim.api.nvim_buf_get_name(b) ~= ""
  end, vim.api.nvim_list_bufs())
  if #bufs == 0 then
    return
  end

  local session_path = get_session_path()
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
  print("Saved current session to " .. session_path)
end

local function restore_session()
  local session_path = get_session_path()
  if vim.fn.filereadable(session_path) ~= 0 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))
    print("Restored session from " .. session_path)
  else
    print("No saved session found at " .. session_path)
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = save_session,
})

vim.api.nvim_create_user_command("SaveSession", save_session, { desc = "Save current session" })
vim.api.nvim_create_user_command("RestoreSession", restore_session, { desc = "Restore session from current directory" })
map("n", "<leader>r", "<cmd>RestoreSession<cr>", { desc = "[r]estore session" })

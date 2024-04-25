-- KEYMAPS (non plugin specific)
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("t", "<C-h>", "<cmd>wincmd h<CR>")
map("t", "<C-j>", "<cmd>wincmd j<CR>")
map("t", "<C-k>", "<cmd>wincmd k<CR>")
map("t", "<C-l>", "<cmd>wincmd l<CR>")

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- C-Backspace for deleting word in insert mode (equivalent to C-w)
map("i", "<C-H>", "<C-W>", { desc = "Delete last word" })

-- move cursor with alt-hjkl in insert mode
map("c", "<M-h>", "<Left>", { silent = false, desc = "Left" })
map("c", "<M-l>", "<Right>", { silent = false, desc = "Right" })
map("i", "<M-h>", "<Left>", { noremap = false, desc = "Left" })
map("i", "<M-j>", "<Down>", { noremap = false, desc = "Down" })
map("i", "<M-k>", "<Up>", { noremap = false, desc = "Up" })
map("i", "<M-l>", "<Right>", { noremap = false, desc = "Right" })
map("t", "<M-h>", "<Left>", { desc = "Left" })
map("t", "<M-j>", "<Down>", { desc = "Down" })
map("t", "<M-k>", "<Up>", { desc = "Up" })
map("t", "<M-l>", "<Right>", { desc = "Right" })

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
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "[l]azy (plugin manager)" })

-- new file
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "[n]ew File" })

-- quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "[q]uit all" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- toggle word wrap
map("n", "<leader>w", "<cmd>set wrap!<cr>", { desc = "[w]ord wrap (toggle)" })

-- d,c,x delete to 'd', 'c', 'x' registers by default for a better copy paste experience
-- Now we can copy-delete-paste without losing the first copy
-- To paste from the delete registers use "dp, "cp, "xp
-- The default delete registers of " and - still work as expected
map("n", "d", '"dd')
map("v", "d", '"dd')
map("n", "D", '"dD')
map("v", "D", '"dD')

map("n", "x", '"xx')
map("v", "x", '"xx')
map("n", "X", '"xX')
map("v", "X", '"xX')

map("n", "c", '"cc')
map("v", "c", '"cc')
map("n", "C", '"cC')
map("v", "C", '"cC')

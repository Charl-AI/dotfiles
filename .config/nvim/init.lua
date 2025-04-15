require("options")

-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "[l]azy (plugin manager)", noremap = true, silent = true })

require("lazy").setup({
  -- misc
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "christoomey/vim-tmux-navigator" },

  -- editor
  { "folke/which-key.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "echasnovski/mini.nvim" },
  { "gpanders/nvim-parinfer" },

  -- lsp
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "stevearc/conform.nvim" },
  { "neovim/nvim-lspconfig" },
  { "saghen/blink.cmp", version = "1.*" },
}, {})

vim.cmd.colorscheme("catppuccin-frappe")
require("editor")
require("lsp")
require("repl")

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end


local packer_bootstrap = ensure_packer()
local map = vim.api.nvim_set_keymap

-- sets up C-/ for commenting. For some reason C-_ is equivalent to C-/
-- NB. doesn't work for multi line in visual selection mode, use 'gc' instead
map("n", "<C-_>", ":Commentary<cr>", {noremap = true})


return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-commentary'
  use 'christoomey/vim-tmux-navigator'
  use { 'ggandor/leap.nvim' ,
  	config = function()
       	    require('leap').set_default_keymaps()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

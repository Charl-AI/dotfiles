local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- resize splits if window got resized
local resize_splits_group = vim.api.nvim_create_augroup('ResizeSplits', { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = resize_splits_group,
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
  })

-- go to last loc when opening a buffer
local last_loc_group = vim.api.nvim_create_augroup('LastLoc', { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
group = last_loc_group,
callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
end,
})

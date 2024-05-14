-- A minimalistic REPL using the inbuilt terminal emulator

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- register filetypes to use with the REPL here.
-- The keys are the filetypes and the values are
-- the commands used to start the interpreters
local filetype_cmds = {
	lua = "lua",
	python = "python3",
	fennel = "fennel",
}

-- buffer and window id for the REPL (NB: only one REPL allowed at a time)
vim.g.repl_win_id = nil
vim.g.repl_buf_id = nil
vim.g.repl_channel = nil

local function open_repl(filetype, buf)
	-- error if the filetype has not been registered above
	if filetype_cmds[filetype] == nil then
		local message = "'No REPL registered for filetype: " .. filetype .. "'"
		vim.cmd({ cmd = "echo", args = { message } })
		return
	end

	vim.cmd("below new")
	vim.cmd("wincmd J")
	vim.cmd("resize 10")

	local win = vim.api.nvim_get_current_win()

	-- if a buf id is passed as an arg, populate the new window with
	-- the existing contents, else start the REPL fresh
	if buf ~= nil and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_win_set_buf(win, buf)
	else
		vim.cmd("terminal " .. filetype_cmds[filetype])
		buf = vim.api.nvim_get_current_buf()
	end

	local chan = vim.o.channel
	vim.cmd("wincmd p")

	vim.g.repl_win_id = win
	vim.g.repl_buf_id = buf
	vim.g.repl_channel = chan
end

local function kill_repl()
	if vim.g.repl_buf_id == nil then
		print("No active REPL buffer found")
		return
	end
	vim.api.nvim_buf_delete(vim.g.repl_buf_id, { force = true })
	vim.g.repl_buf_id = nil
	vim.g.repl_channel = nil
end

local function toggle_repl()
	local is_open = vim.g.repl_win_id ~= nil and vim.api.nvim_win_is_valid(vim.g.repl_win_id)

	if is_open then
		vim.api.nvim_win_hide(vim.g.repl_win_id)
		vim.g.repl_win_id = nil
		return
	end

	local filetype = vim.bo.filetype
	open_repl(filetype, vim.g.repl_buf_id)
end

local function restart_repl()
	kill_repl()
	toggle_repl()
end

local function get_visual_lines()
	local b_line, b_col
	local e_line, e_col

	b_line, b_col = unpack(vim.fn.getpos("'<"), 2, 3)
	e_line, e_col = unpack(vim.fn.getpos("'>"), 2, 3)

	if e_line < b_line or (e_line == b_line and e_col < b_col) then
		e_line, b_line = b_line, e_line
		e_col, b_col = b_col, e_col
	end

	local lines = vim.api.nvim_buf_get_lines(0, b_line - 1, e_line, 0)

	if lines == nil or #lines == 0 then
		return
	end
	return lines
end

local function send_to_repl()
	-- start/show REPL if it is hidden or does not exist
	local is_open = vim.g.repl_win_id ~= nil and vim.api.nvim_win_is_valid(vim.g.repl_win_id)
	if is_open == false then
		local filetype = vim.bo.filetype
		open_repl(filetype, vim.g.repl_buf_id)
	end

	if vim.g.repl_channel == nil then
		print("No active REPL channel found")
		return
	end

	local lines = get_visual_lines()

	if #lines > 0 and lines ~= nil then
		lines[#lines] = lines[#lines] .. "\13" -- append <CR> at end
		vim.fn.chansend(vim.g.repl_channel, lines)
	end
end

vim.api.nvim_create_user_command("REPLToggle", toggle_repl, { desc = "Toggle the REPL window" })
vim.api.nvim_create_user_command("REPLKill", kill_repl, { desc = "Kill the existing REPL" })
vim.api.nvim_create_user_command("REPLRestart", restart_repl, { desc = "Restart the current REPL" })
vim.api.nvim_create_user_command("REPLSend", send_to_repl, { desc = "Send contents of the 'i' register to the REPL" })

map("n", "<leader>i", toggle_repl, { desc = "[i]nteractive REPL (toggle)" })
map("v", "<leader>i", send_to_repl, { desc = "[i]nteractively evaluate selection with REPL " })

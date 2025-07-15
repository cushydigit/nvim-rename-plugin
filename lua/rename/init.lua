local M = {}

function M.rename_current_file()
	local old_name = vim.api.nvim_buf_get_name(0)
	local new_name = vim.fn.input("New file name: ", old_name, "file")
	if new_name == "" then
		print("Rename cancelled")
		return
	end

	-- Try to rename file on disk
	local ok, err = os.rename(old_name, new_name)
	if not ok then
		print("Error renaming file: " .. err)
		return
	end

	-- Load the new file in current buffer
	vim.api.nvim_command("edit " .. new_name)

	-- Delete old buffer
	vim.api.nvim_command("bdelete #")

	print("File renamed to " .. new_name)
end

function M.setup()
	vim.keymap.set(
		"n",
		"<leader>rn",
		M.rename_current_file,
		{ noremap = true, silent = true, desc = "Rename current file" }
	)
end

return M

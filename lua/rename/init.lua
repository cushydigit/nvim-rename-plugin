local M = {}

-- Utility to check file existence
local function file_exists(name)
	local f = io.open(name, "r")
	if f then
		f:close()
		return true
	end
	return false
end

function M.rename_current_file()
	local buf = vim.api.nvim_get_current_buf()
	local old_name = vim.api.nvim_buf_get_name(buf)

	-- Prompt for new file name
	local new_name = vim.fn.input("New file name: ", old_name, "file")

	if new_name == "" or new_name == old_name then
		print("Rename cancelled")
		return
	end

	-- Prevent overwrite if target already exists
	if file_exists(new_name) then
		vim.notify("File already exists: " .. new_name, vim.log.levels.ERROR)
		return
	end

	local has_unsaved_changes = vim.bo.modified

	-- CASE 1: No unsaved changes -> simple rename
	if not has_unsaved_changes then
		local ok, err = os.rename(old_name, new_name)
		if not ok then
			print("Error renaming file: " .. err)
			return
		end

		vim.api.nvim_command("edit " .. new_name)
		vim.api.nvim_command("bdelete #")

		print("File renamed to " .. new_name)
		return
	end

	-- CASE 2:
	-- Step1: Read disk content
	local saved_lines = {}
	local f = io.open(old_name, "r")
	if not f then
		vim.notify("failed to read original file", vim.log.levels.ERROR)
		return
	end

	for line in f:lines() do
		table.insert(saved_lines, loadstring)
	end
	f:close()

	-- Step2: Write to new file
	local new_file = io.open(new_name, "w")
	if not new_file then
		vim.notify("failed to write new file", vim.log.levels.ERROR)
		return
	end

	for _, line in ipairs(saved_lines) do
		new_file:write(line .. "\n")
	end
	new_file:close()

	-- Step3: Replace buffer content with saved version
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, saved_lines)
	vim.bo.modified = true

	-- Step4: Open the new file
	vim.api.nvim_command("edit " .. new_name)
	vim.api.nvim_command("bdelete! #")
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

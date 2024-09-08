local BufState = require("lazycf.BufState")
local config = require("lazycf.config")
local M = {}

local function read_file_async(filepath)
	coroutine.yield()
	local file = io.open(filepath, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content
	else
		print("Error opening file: " .. filepath, vim.notify.ERROR)
		return nil
	end
end

local function handle_file_content(content)
	BufState.set_data(content)
end

M.init = function()
	vim.api.nvim_create_autocmd("BufWinEnter", {
		pattern = { "*.cpp" },
		callback = function()
			local root_dir = vim.fn.getcwd()
			local filename = vim.fn.expand("%:t")
			local filepath = vim.fn.expand("%:p")
			filename = filename:gsub("%s+", "")
			filename = filename:sub(1, #filename - 4)
			local metadataFile = root_dir .. "/.cph/." .. filename .. ".json"

			config.root_dir = root_dir
			config.filename = filename
			config.filepath = filepath

			if metadataFile then
				local co = coroutine.create(read_file_async)
				coroutine.resume(co, metadataFile)
				vim.schedule(function()
					while true do
						local status, result = coroutine.resume(co)
						if not status then
							vim.notify("Error reading file: " .. result, vim.notify.ERROR)
							break
						end
						if result then
							handle_file_content(result)
							break
						end
					end
				end)
			end
		end,
	})
end

return M

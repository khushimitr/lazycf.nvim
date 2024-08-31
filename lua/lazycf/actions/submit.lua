local curl = require("plenary.curl")

local url = "http://localhost:27121"

local M = {}

---comment
---@param data Problem
local generateDataToSubmit = function(data)
	local file = io.open(data.srcPath, "r")
	local content = ""
	if file ~= nil then
		content = file:read("*a")
		file:close()
	end
	return {
		empty = false,
		url = data.url,
		problemName = data.fname,
		sourceCode = content,
		languageId = 89,
	}
end

M.submitIt = function()
	local root_dir = vim.fn.getcwd()
	local filename = vim.fn.expand("%:t")
	-- local filePath = vim.fn.expand("%:p")
	filename = filename:gsub("%s+", "")
	filename = filename:sub(1, #filename - 4)
	local metadataFile = root_dir .. "/.cph/." .. filename .. ".json"
	local file = io.open(metadataFile, "r")
	local data
	if file ~= nil then
		local content = file:read("*a")
		file:close()
		data = vim.json.decode(content)
	end
	local body = generateDataToSubmit(data)
end
return M

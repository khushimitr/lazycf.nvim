local Problem = require("lazycf.problem")

--- @class M
---@field data Problem
local M = {}

function M.set_data(json_content)
	M.data = vim.json.decode(json_content)
end

function M.get_data()
	return M.data
end

return M

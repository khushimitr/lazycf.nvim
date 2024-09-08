local n = require("nui-components")
local state = require("lazycf.ui.state")
local BufState = require("lazycf.BufState")
local M = {}

M.init = function()
	return n.rows(n.paragraph({
		border_style = "rounded",
		border_label = "Exp Output",
		flex = 1,
		is_focusable = false,
		lines = state.focus_id:map(function(val)
			local res = ""
			if val then
				if state.result:get_value() then
					res = state.result:get_value()[val].output
				else
					res = BufState.get_data().tests[val].output
				end
			end
			return res
		end),
	}))
end

return M

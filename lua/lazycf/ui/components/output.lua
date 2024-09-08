local n = require("nui-components")
local state = require("lazycf.ui.state")
local M = {}

M.init = function()
	return n.rows(n.paragraph({
		border_style = "rounded",
		border_label = "My Output",
		flex = 1,
		is_focusable = false,
		lines = state.focus_id:map(function(val)
			local res = ""
			if val then
				if state.result:get_value() then
					if state.result:get_value()[val].result.signal == 0 then
						res = state.result:get_value()[val].result.stdout
					else
						res = state.result:get_value()[val].result.stderr
					end
				end
			end
			return res
		end),
	}))
end

return M

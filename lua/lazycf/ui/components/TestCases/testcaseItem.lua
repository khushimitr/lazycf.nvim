local n = require("nui-components")
local state = require("lazycf.ui.state")

local M = {}

M.init = function(id, ind)
	local loc_state = n.create_signal({
		id = id,
	})

	return n.columns(
		n.paragraph({
			truncate = true,
			is_focusable = true,
			lines = "Testcase #" .. ind .. " : ",
			on_focus = function()
				local this = loc_state
				state.focus_id = nil
				state.focus_id = this.id:get_value()
			end,
		}),
		n.paragraph({
			flex = 1,
			truncate = true,
			is_focusable = false,
			lines = state.result:map(function(val)
				local this = loc_state
				local res = ""
				local og_id = this.id:get_value()
				if og_id and val and val[og_id] then
					res = val[og_id].status
				end
				return res
			end),
		})
	)
end

return M

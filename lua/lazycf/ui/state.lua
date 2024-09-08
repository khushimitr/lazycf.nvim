local n = require("nui-components")

local state = n.create_signal({
	isLoading = false,
	result = nil,
	focus_id = nil,
})

return state

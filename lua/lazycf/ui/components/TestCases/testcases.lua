local n = require("nui-components")
local state = require("lazycf.ui.state")
local TestCaseItem = require("lazycf.ui.components.TestCases.testcaseItem")
local BufState = require("lazycf.BufState")
local Actions = require("lazycf.actions.tests")

local TestCases = {}

local generateChildren = function(res)
	local children = {}
	local ind = 1
	for key, _ in pairs(res.tests) do
		table.insert(children, TestCaseItem.init(key, ind))
		ind = ind + 1
	end
	return children
end

TestCases.init = function()
	local jsonData = BufState.get_data()
	return n.rows(
		{ flex = 1 },
		n.button({
			label = "Run All Testcases",
			autofocus = true,
			on_press = function()
				state.isLoading = true
				Actions.runTestcases()
			end,
			on_focus = function()
				state.focus_id = nil
			end,
		}),
		n.spinner({
			flex = 1,
			is_loading = state.isLoading,
			padding = { left = 1 },
			hidden = state.isLoading:negate(),
		}),
		table.unpack(generateChildren(jsonData))
	)
end

return TestCases

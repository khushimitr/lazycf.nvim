local tests = require("lazycf.actions.tests")
local submit = require("lazycf.actions.submit")
local Vue = require("lazycf.ui")

local mappings = {}

mappings.defaultMappings = {
	["<leader>rt"] = {
		action = tests.runTestcases,
		description = "Run testcases",
	},
	["<leader>rs"] = {
		action = submit.submitIt,
		description = "Submit to codeforces",
	},
	["<leader>rv"] = {
		action = function()
			Vue.open()
		end,
		description = "Open View",
	},
}

function mappings:registerKeyMaps()
	local myKeymaps = self.defaultMappings
	for k, v in pairs(myKeymaps) do
		vim.keymap.set("n", k, v.action, { desc = v.description })
	end
end

return mappings

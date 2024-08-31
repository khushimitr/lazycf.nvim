local tests = require("lazycf.actions.tests")

local mappings = {}

mappings.defaultMappings = {
	["<leader>rt"] = {
		action = tests.runTestcases,
		description = "Run testcases",
	},
}

return mappings

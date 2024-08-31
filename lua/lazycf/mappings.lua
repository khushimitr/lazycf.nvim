local tests = require("lazycf.actions.tests")
local submit = require("lazycf.actions.submit")
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
}

return mappings

local ui = require("lazycf.ui")

local M = {}
local function runTestCase(filePath, apathFile, testCase)
	local result = vim.system({ "g++", filePath }, { text = true }):wait()
	if result.code == 0 and result.stderr == "" then
		print("Compilation successful")
		local result2 = vim.system({ apathFile }, { stdin = testCase.input }):wait()
		if result2.stdout == testCase.output then
			print("pass")
		else
			print("fail")
		end
	else
		print("Compilation failed")
	end
end

local function executeTestCase(filename, root_dir, filePath)
	print("Executing test cases")
	filename = filename:gsub("%s+", "")
	filename = filename:sub(1, #filename - 4)
	local metadataFile = root_dir .. "/.cph/." .. filename .. ".json"
	local apathFile = root_dir .. "/./a.out"

	-- read testcases
	--
	local testCases = {}
	local file = io.open(metadataFile, "r")
	if file ~= nil then
		local content = file:read("*a")
		file:close()
		local data = vim.json.decode(content)
		testCases = data.tests
	end
	for i = 1, #testCases do
		runTestCase(filePath, apathFile, testCases[i])
	end
end
M.runTestcases = function()
	print("Running tests")

	local root_dir = vim.fn.getcwd()
	local filename = vim.fn.expand("%:t")
	local filePath = vim.fn.expand("%:p")
	-- ui.open_popup()
	executeTestCase(filename, root_dir, filePath)
end

return M

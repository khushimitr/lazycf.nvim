local config = require("lazycf.config")
local state = require("lazycf.ui.state")
local M = {}

local function runTestCase(filePath, apathFile, testCase)
	local result = vim.system({ "g++", filePath }, { text = true }):wait()
	if result.code == 0 and result.stderr == "" then
		local result2 = vim.system({ apathFile }, { stdin = testCase.input }):wait()
		testCase.result = result2
		if result2.stdout == testCase.output then
			testCase.status = "Passed"
		else
			testCase.status = "Failed"
		end
	else
		testCase.status = "Failed"
	end
	P(testCase)
	return testCase
end

local function executeTestCase(filename, root_dir, filePath)
	coroutine.yield()
	local metadataFile = root_dir .. "/.cph/." .. filename .. ".json"
	local apathFile = root_dir .. "/./a.out"

	print(metadataFile)
	local testCases = {}
	local file = io.open(metadataFile, "r")
	if file ~= nil then
		local content = file:read("*a")
		file:close()
		local data = vim.json.decode(content)
		testCases = data.tests
	end
	P(testCases)
	local res = {}
	for k, v in pairs(testCases) do
		local t = runTestCase(filePath, apathFile, v)
		res[k] = t
	end
	P(res)
	return res
end

M.runTestcases = function()
	local results = {}
	local co = coroutine.create(executeTestCase)
	coroutine.resume(co, config.filename, config.root_dir, config.filepath)
	vim.schedule(function()
		while true do
			local status, result = coroutine.resume(co)
			if not status then
				state.isLoading = false
				vim.notify("Something went wrong" .. result, vim.log.levels.ERROR)
				break
			end
			if result then
				state.isLoading = false
				state.result = result
				break
			end
		end
	end)
end

return M

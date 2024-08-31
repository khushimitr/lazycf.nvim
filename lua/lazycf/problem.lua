---@class Testcase
---@field input string
---@field output string
---@field id number

---@class Problem
---@field name string
---@field url string
---@field interactive boolean
---@field memoryLimit number
---@field timeLimit number
---@field group string
---@field tests Testcase[]
---@field srcPath string
---@field lc boolean
---@field fname string
local Problem = {}

Problem.__index = Problem

function Problem:new(name, url, interactive, memoryLimit, timeLimit, group, tests, srcPath, lc)
	tests = tests or {}
	return setmetatable({
		name = name,
		url = url,
		interactive = interactive,
		memoryLimit = memoryLimit,
		timeLimit = timeLimit,
		group = group,
		tests = tests,
		srcPath = srcPath,
		lc = lc,
	}, self)
end

local function generated_random_integer_id()
	return math.random(2 ^ 31 - 1)
end

function Problem:giveTestIds()
	for i = 1, #self.tests do
		self.tests[i].id = generated_random_integer_id()
	end
end

function Problem:extractNameFromUrl()
	local parts = vim.split(self.url, "/")
	local fname = ""
	if string.find(self.url, "contest") then
		--Url is like https://codeforces.com/contest/1344/problem/F
		fname = parts[#parts - 2] .. parts[#parts]
	else
		--Url is like https://codeforces.com/problemset/problem/1344/F
		fname = parts[#parts - 1] .. parts[#parts]
	end

	self.fname = fname
	return fname
end

local function writeMetaDataFile(metadatafile, problem)
	-- create metadata file if it doesn't exist
	if io.open(metadatafile, "r") then
		print("File already exists")
	else
		local file = io.open(metadatafile, "w")
		if file == nil then
			print("Error: Could not open file for writing")
			return
		end
		file:write(vim.json.encode(problem))
		file:close()
	end
end

function Problem:writeProblemToJson(cwd)
	local cphFolder = cwd .. "/.cph"

	-- create .cph folder if it doesn't exist
	vim.uv.fs_stat(cphFolder, function(err, stat)
		if err then
			vim.uv.fs_mkdir(cphFolder, 511, function(errmkdir)
				if errmkdir then
					print("Error: Could not create .cph directory")
					return
				else
					local metadatafile = cphFolder .. "/." .. self.fname .. ".json"
					writeMetaDataFile(metadatafile, self)
				end
			end)
		else
			print("Folder already exists")
			local metadatafile = cphFolder .. "/." .. self.fname .. ".json"
			writeMetaDataFile(metadatafile, self)
		end
	end)
end

function Problem:print()
	print("Problem:")
	print("  name: " .. self.name)
	print("  url: " .. self.url)
	print("  interactive: " .. tostring(self.interactive))
	print("  memoryLimit: " .. self.memoryLimit)
	print("  timeLimit: " .. self.timeLimit)
	print("  group: " .. self.group)
	print("  srcPath: " .. self.srcPath)
	print("  lc: " .. tostring(self.lc))
	print("  fname: " .. self.fname)
	print("  tests:")
	for i = 1, #self.tests do
		print("    - id: " .. self.tests[i].id)
		print("      input: " .. self.tests[i].input)
		print("      output: " .. self.tests[i].output)
	end
end

return Problem

local Problem = require("lazycf.problem")
local config = require("lazycf.config"):new()

local Server = {}

local myserver = nil

function GiveServerInstance()
	if myserver == nil then
		myserver = Server:new()
	end
	return myserver
end

Server.__index = Server

function Server:new()
	return setmetatable({
		server = vim.uv.new_tcp(),
		result = nil,
	}, self)
end

function Server:handleGET()
	if self.result then
		local data = vim.json.encode(self.result)
		self.client:write([[HTTP/1.1 200 OK
Connection: keep-alive
Keep-Alive: timeout=5
Content-Type: application/json

]] .. data)
		self.result = nil
	else
		local data = vim.json.encode({ empty = true })
		self.client:write([[HTTP/1.1 200 OK
Connection: keep-alive
Keep-Alive: timeout=5
Content-Type: application/json

]] .. data)
	end
end

function Server:handlePOST(body, cwd)
	local json_data = vim.json.decode(body)
	-- if err then
	-- 	print("Error parsing JSON: " .. err)
	-- 	stream:write("Invalid JSON\n")
	-- else
	-- Print JSON data to Neovim

	print("Received JSON : " .. vim.json.encode(json_data) .. "\n")

	local problem = Problem:new(
		json_data.name,
		json_data.url,
		json_data.interactive,
		json_data.memoryLimit,
		json_data.timeLimit,
		json_data.group,
		json_data.tests,
		"srcPath",
		"local"
	)

	-- giveTestIds() is a function that assigns test ids to the test cases
	problem:giveTestIds()

	-- extractNameFromUrl() is a function that extracts the problem name from the url
	problem:extractNameFromUrl()

	local defaultLanguage = config.defaultLanguage

	local sourcePath = cwd .. "/" .. problem.fname .. defaultLanguage
	problem.srcPath = sourcePath

	problem:print()

	if io.open(sourcePath, "r") then
		print("File already exists")
	else
		print("File does not exist")
		local file = io.open(sourcePath, "w")
		file:close()
	end

	-- open the file created above
	vim.uv.fs_open(sourcePath, "r", 438, function(err, fd)
		if err then
			print("Error opening file: " .. err)
			return
		end
		vim.schedule(function()
			vim.cmd("edit " .. sourcePath)
		end)
	end)

	-- create .cph folder and write metadata file in it
	problem:writeProblemToJson(cwd)
end

function Server:on_new_connection(cwd)
	local buffer = ""

	self.client:read_start(function(err, data)
		if err then
			print("Error reading data: " .. err)
			return
		end
		if data then
			buffer = buffer .. data
			local headers_end = buffer:find("\r\n\r\n")
			if headers_end then
				local body = buffer:sub(headers_end + 4)

				-- Extract the HTTP method
				local method = buffer:match("^(%w+)")
				if method == "GET" then
					self:handleGET()
				elseif method == "POST" then
					-- Attempt to parse the JSON body
					-- end
					self:handlePOST(body, cwd)
				else
					self.client:write("Only POST requests are supported\n")
				end

				-- Close connection after processing
				self.client:shutdown()

				self.client:close()
			end
		end
	end)
end

function Server:startServer()
	local cwd = vim.fn.getcwd()
	self.server:bind("127.0.0.1", 27121)
	self.server:listen(128, function(err)
		if err then
			print("Error starting server: " .. err)
			return
		end
		self.client = vim.uv.new_tcp()
		self.server:accept(self.client)
		self:on_new_connection(cwd)
	end)
end

function Server:setResult(result)
	self.result = result
end

return Server

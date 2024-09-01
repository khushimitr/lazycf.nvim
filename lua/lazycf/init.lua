local Problem = require("lazycf.problem")
local Server = require("lazycf.server")
local config = require("lazycf.config"):new()
-- local Server = require("lazycf.server")

local function on_new_connection(stream, cwd)
	local buffer = ""

	stream:read_start(function(err, data)
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
					stream:write(
						"HTTP/1.1 200 OK\r\n"
							.. "Content-Type: text/plain\r\n"
							.. "Content-Length: 13\r\n"
							.. "Connection: close\r\n\r\n"
							.. "Hello, World!"
					)
				elseif method == "POST" then
					-- Attempt to parse the JSON body
					local json_data = vim.json.decode(body)
					-- if err then
					-- 	print("Error parsing JSON: " .. err)
					-- 	stream:write("Invalid JSON\n")
					-- else
					-- Print JSON data to Neovim

					print("Received JSON : " .. vim.json.encode(json_data) .. "\n")
					stream:write("JSON data received\n")

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

					-- end
				else
					stream:write("Only POST requests are supported\n")
				end

				-- Close connection after processing
				stream:shutdown()

				stream:close()
			end
		end
	end)
end

local augroup = vim.api.nvim_create_augroup("lazycf", { clear = true })

local uv = vim.uv

-- Function to start the TCP server
local function start_server()
	local server = uv.new_tcp()
	local client = uv.new_tcp()
	local cwd = vim.fn.getcwd()
	-- config:setCwd(cwd)

	-- Bind to the port
	server:bind("127.0.0.1", 27121)
	-- Start listening for incoming connections
	server:listen(128, function(err)
		if err then
			print("Error starting server: " .. err)
			return
		end

		-- Accept new connections
		client = uv.new_tcp()
		server:accept(client)
		on_new_connection(client, cwd)
	end)
end

local function main()
	config:registerKeyMaps()

	-- Start the server
	-- start_server()

	local server = GiveServerInstance()
	server:startServer()
end

local function setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Start the server to listen for any codeforces problem",
		once = true,
		callback = main,
	})
end

return { setup = setup }

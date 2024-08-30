local function on_new_connection(stream)
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

				if method == "POST" then
					-- Attempt to parse the JSON body
					local json_data = vim.json.decode(body)
					-- if err then
					-- 	print("Error parsing JSON: " .. err)
					-- 	stream:write("Invalid JSON\n")
					-- else
					-- Print JSON data to Neovim
					print("Received JSON : " .. vim.json.encode(json_data) .. "\n")
					stream:write("JSON data received\n")
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

	-- Bind to the port
	server:bind("127.0.0.1", 27121)

	-- Start listening for incoming connections
	server:listen(128, function(err)
		if err then
			print("Error starting server: " .. err)
			return
		end
		print("Server listening on port 27121")

		-- Accept new connections
		local client = uv.new_tcp()
		server:accept(client)
		on_new_connection(client)
	end)
end

local function setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Start the server to listen for any codeforces problem",
		once = true,
		callback = start_server,
	})
end

return { setup = setup }

-- local uv = vim.uv
--
-- -- Function to start the TCP server
-- local function start_server()
-- 	local server = uv.new_tcp()
--
-- 	-- Bind to the port
-- 	server:bind("127.0.0.1", 27121)
--
-- 	-- Start listening for incoming connections
-- 	server:listen(128, function(err)
-- 		if err then
-- 			print("Error starting server: " .. err)
-- 			return
-- 		end
-- 		print("Server listening on port 27121")
--
-- 		-- Accept new connections
-- 		local client = uv.new_tcp()
-- 		server:accept(client)
-- 		require("lazycf").on_new_connection(client)
-- 	end)
-- end
--
-- -- Start the server
-- start_server()

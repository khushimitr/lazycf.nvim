local mappings = require("lazycf.mappings")

---@class Config
---@field timeout number
---@field port number
---@field extensions string[]
---@field defaultLanguage string
---@field defaultKeymaps table
local Config = {}

function Config:new()
	local config = {
		-- for a testcase run, the amount of time to wait for the output
		timeout = 10000,
		-- the port on which the server listens for the parser payload
		port = 27121,
		extensions = { ".cpp", ".c", ".py", ".java" },
		defaultLanguage = ".cpp",
	}
	setmetatable(config, self)
	self.__index = self
	return config
end

function Config:registerKeyMaps()
	local myKeymaps = mappings.defaultMappings

	for k, v in pairs(myKeymaps) do
		vim.keymap.set("n", k, v.action, { desc = v.description })
	end
	self.defaultKeymaps = myKeymaps
end

return Config

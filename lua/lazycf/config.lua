---@class Config
---@field timeout number
---@field port number
---@field extensions string[]
---@field defaultLanguage string
---@field cwd string
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

function setCwd(self, cwd)
	self.cwd = cwd
end

return Config

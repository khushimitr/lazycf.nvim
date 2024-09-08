local Config = {
	-- for a testcase run, the amount of time to wait for the output
	timeout = 10000,
	-- the port on which the server listens for the parser payload
	port = 27121,
	extensions = { ".cpp", ".c", ".py", ".java" },
	defaultLanguage = ".cpp",
}
return Config

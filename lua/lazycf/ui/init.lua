local n = require("nui-components")
local Testcase = require("lazycf.ui.components.TestCases.testcases")
local Output = require("lazycf.ui.components.output")
local Input = require("lazycf.ui.components.input")
local ExpOutput = require("lazycf.ui.components.exOutput")

local renderer = n.create_renderer({
	width = 80,
	height = 15,
	on_unmount = function()
		print("renderer unmounting")
	end,
})

local body = function()
	return n.columns(n.rows(Testcase.init(), Input.init(), ExpOutput.init()), Output.init())
end

local M = {}

M.open = function()
	renderer:render(body)
end
return M

-- local Layout = require("nui.layout")
-- local Popup = require("nui.popup")
--
-- local top_popup = Popup({ border = "double" })
-- local bottom_left_popup = Popup({ border = "single" })
-- local bottom_right_popup = Popup({ border = "single" })
--
-- local layout = Layout(
-- 	{
-- 		position = "50%",
-- 		size = {
-- 			width = 80,
-- 			height = 40,
-- 		},
-- 	},
-- 	Layout.Box({
-- 		Layout.Box(top_popup, { size = "40%" }),
-- 		Layout.Box({
-- 			Layout.Box(bottom_left_popup, { size = "50%" }),
-- 			Layout.Box(bottom_right_popup, { size = "50%" }),
-- 		}, { dir = "row", size = "60%" }),
-- 	}, { dir = "col" })
-- )
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local popup = Popup({
	enter = true,
	focusable = true,
	border = {
		style = "rounded",
	},
	position = "50%",
	size = {
		width = "80%",
		height = "60%",
	},
})

-- mount/open the component

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
	popup:unmount()
end)

-- set content
vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })
local M = {}

M.open_popup = function()
	print("open_popup")
	popup:mount()
end

return M

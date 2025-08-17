local api = require("api")

local M = {}
local wnd = nil
local config = {}

function M.Open()
	wnd = api.Interface:CreateWindow("aav-conf", "Configure Companion App")
	wnd:SetExtent(600, 300)
	wnd:Show(false)




	wnd:Show(true)
end

function M.Unload()
	if wnd ~= nil then
		wnd:Show(false)
	end
end

return M
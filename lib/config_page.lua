local api = require("api")

local M = {}
local wnd = nil
local config = {}

function M.Open()
	wnd = api.Interface:CreateWindow("aav-conf", "Configure Companion App")
	wnd:SetExtent(600, 300)
	wnd:Show(false)

    local templbl = wnd:CreateChildWidget("label", "templbl", 0, true)
    templbl:SetText("~Under Construction~")
    templbl.style:SetAlign(ALIGN.CENTER)
    templbl.style:SetFontSize(FONT_SIZE.LARGE)
    templbl.style:SetColor(0.400, 0.251, 0.043, 1)
    templbl:AddAnchor("TOP", wnd, 0, 150)


	wnd:Show(true)
end

function M.Unload()
	if wnd ~= nil then
		wnd:Show(false)
	end
end

return M
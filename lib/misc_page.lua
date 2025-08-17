local api = require("api")
local vibe = require("auto_vibrator/vibe_writer")

local M = {}
local wnd
local settings = vibe.get_secondary_settings()

function M.Open(reloadFn)
	wnd = api.Interface:CreateWindow("aav-pop", "Misc Settings")
	wnd:SetExtent(300, 450)
	wnd:Show(false)

	local infolbl = wnd:CreateChildWidget("label", "infolbl", 0, true)
	infolbl:SetText("Hold shift to increase increments")
	infolbl.style:SetAlign(ALIGN.CENTER)
    infolbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    infolbl.style:SetColor(0.400, 0.251, 0.043, 1)
    infolbl:AddAnchor("TOP", wnd, 0, 40)

	-- Death Intensity
	local deathIntensitylbl = wnd:CreateChildWidget("label", "deathIntensitylbl", 0, true)
	deathIntensitylbl:SetText("Death intensity 0 - 1")
	deathIntensitylbl.style:SetAlign(ALIGN.CENTER)
    deathIntensitylbl.style:SetFontSize(FONT_SIZE.LARGE)
    deathIntensitylbl.style:SetColor(0.400, 0.251, 0.043, 1)
    deathIntensitylbl:AddAnchor("TOP", wnd, 0, 80)

    local deathIntValuelbl = wnd:CreateChildWidget("label", "deathIntValuelbl", 0, true)
    deathIntValuelbl:SetText(tostring(settings.deathIntensity))
    deathIntValuelbl.style:SetAlign(ALIGN.CENTER)
    deathIntValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    deathIntValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    deathIntValuelbl:AddAnchor("TOP", deathIntensitylbl, 0, 30)

	local deathIntIncreaseBtn = wnd:CreateChildWidget("button", "deathIntIncreaseBtn", 0, true)
    deathIntIncreaseBtn:SetExtent(20, 20)
    deathIntIncreaseBtn:SetText(">")
    deathIntIncreaseBtn:AddAnchor("CENTER", deathIntValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(deathIntIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    deathIntIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.deathIntensity = (settings.deathIntensity + 0.1)
        else
            settings.deathIntensity = (settings.deathIntensity + 0.01)
        end
        if settings.deathIntensity > 1 then settings.deathIntensity = 1 end
        deathIntValuelbl:SetText(tostring(settings.deathIntensity)) 
    end)

    local deathIntDecreaseBtn = wnd:CreateChildWidget("button", "deathIntDecreaseBtn", 0, true)
    deathIntDecreaseBtn:SetExtent(20, 20)
    deathIntDecreaseBtn:SetText("<")
    deathIntDecreaseBtn:AddAnchor("CENTER", deathIntValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(deathIntDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    deathIntDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.deathIntensity = (settings.deathIntensity - 0.1)
        else
            settings.deathIntensity = (settings.deathIntensity - 0.01)
        end
        if settings.deathIntensity < 0 then settings.deathIntensity = 0 end
        deathIntValuelbl:SetText(tostring(settings.deathIntensity)) 
    end)

    -- Death Duration
    local deathDurlbl = wnd:CreateChildWidget("label", "deathDurlbl", 0, true)
	deathDurlbl:SetText("Death duration in Ms")
	deathDurlbl.style:SetAlign(ALIGN.CENTER)
    deathDurlbl.style:SetFontSize(FONT_SIZE.LARGE)
    deathDurlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    deathDurlbl:AddAnchor("TOP", wnd, 0, 160)

    local deathDurValuelbl = wnd:CreateChildWidget("label", "deathDurValuelbl", 0, true)
    deathDurValuelbl:SetText(tostring(settings.deathDuration))
    deathDurValuelbl.style:SetAlign(ALIGN.CENTER)
    deathDurValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    deathDurValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    deathDurValuelbl:AddAnchor("TOP", deathDurlbl, 0, 30)

	local durIncreaseBtn = wnd:CreateChildWidget("button", "durIncreaseBtn", 0, true)
    durIncreaseBtn:SetExtent(20, 20)
    durIncreaseBtn:SetText(">")
    durIncreaseBtn:AddAnchor("CENTER", deathDurValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(durIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    durIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.deathDuration = (settings.deathDuration + 1000)
        else
            settings.deathDuration = (settings.deathDuration + 100)
        end
        deathDurValuelbl:SetText(tostring(settings.deathDuration)) 
    end)

    local deathDurDecreaseBtn = wnd:CreateChildWidget("button", "deathDurDecreaseBtn", 0, true)
    deathDurDecreaseBtn:SetExtent(20, 20)
    deathDurDecreaseBtn:SetText("<")
    deathDurDecreaseBtn:AddAnchor("CENTER", deathDurValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(deathDurDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    deathDurDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.deathDuration = (settings.deathDuration - 1000)
        else
            settings.deathDuration = (settings.deathDuration - 100)
        end
        if settings.deathDuration < 0 then settings.deathDuration = 0 end
        deathDurValuelbl:SetText(tostring(settings.deathDuration)) 
    end)

    -- Hard CC Intensity
	local hardCCIntensitylbl = wnd:CreateChildWidget("label", "hardCCIntensitylbl", 0, true)
	hardCCIntensitylbl:SetText("Hard CC intensity 0 - 1")
	hardCCIntensitylbl.style:SetAlign(ALIGN.CENTER)
    hardCCIntensitylbl.style:SetFontSize(FONT_SIZE.LARGE)
    hardCCIntensitylbl.style:SetColor(0.400, 0.251, 0.043, 1)
    hardCCIntensitylbl:AddAnchor("TOP", wnd, 0, 240)

    local hardCCIntValuelbl = wnd:CreateChildWidget("label", "hardCCIntValuelbl", 0, true)
    hardCCIntValuelbl:SetText(tostring(settings.hardCCIntensity))
    hardCCIntValuelbl.style:SetAlign(ALIGN.CENTER)
    hardCCIntValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    hardCCIntValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    hardCCIntValuelbl:AddAnchor("TOP", hardCCIntensitylbl, 0, 30)

	local hardCCIntIncreaseBtn = wnd:CreateChildWidget("button", "hardCCIntIncreaseBtn", 0, true)
    hardCCIntIncreaseBtn:SetExtent(20, 20)
    hardCCIntIncreaseBtn:SetText(">")
    hardCCIntIncreaseBtn:AddAnchor("CENTER", hardCCIntValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(hardCCIntIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    hardCCIntIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.hardCCIntensity = (settings.hardCCIntensity + 0.1)
        else
            settings.hardCCIntensity = (settings.hardCCIntensity + 0.01)
        end
        if settings.hardCCIntensity > 1 then settings.hardCCIntensity = 1 end
        hardCCIntValuelbl:SetText(tostring(settings.hardCCIntensity)) 
    end)

    local hardCCIntDecreaseBtn = wnd:CreateChildWidget("button", "hardCCIntDecreaseBtn", 0, true)
    hardCCIntDecreaseBtn:SetExtent(20, 20)
    hardCCIntDecreaseBtn:SetText("<")
    hardCCIntDecreaseBtn:AddAnchor("CENTER", hardCCIntValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(hardCCIntDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    hardCCIntDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.hardCCIntensity = (settings.hardCCIntensity - 0.1)
        else
            settings.hardCCIntensity = (settings.hardCCIntensity - 0.01)
        end
        if settings.hardCCIntensity < 0 then settings.hardCCIntensity = 0 end
        hardCCIntValuelbl:SetText(tostring(settings.hardCCIntensity)) 
    end)

    -- Soft CC Intensity
	local softCCIntensitylbl = wnd:CreateChildWidget("label", "softCCIntensitylbl", 0, true)
	softCCIntensitylbl:SetText("Soft CC intensity 0 - 1")
	softCCIntensitylbl.style:SetAlign(ALIGN.CENTER)
    softCCIntensitylbl.style:SetFontSize(FONT_SIZE.LARGE)
    softCCIntensitylbl.style:SetColor(0.400, 0.251, 0.043, 1)
    softCCIntensitylbl:AddAnchor("TOP", wnd, 0, 310)

    local softCCIntValuelbl = wnd:CreateChildWidget("label", "softCCIntValuelbl", 0, true)
    softCCIntValuelbl:SetText(tostring(settings.softCCIntensity))
    softCCIntValuelbl.style:SetAlign(ALIGN.CENTER)
    softCCIntValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    softCCIntValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    softCCIntValuelbl:AddAnchor("TOP", softCCIntensitylbl, 0, 30)

	local softCCIntIncreaseBtn = wnd:CreateChildWidget("button", "softCCIntIncreaseBtn", 0, true)
    softCCIntIncreaseBtn:SetExtent(20, 20)
    softCCIntIncreaseBtn:SetText(">")
    softCCIntIncreaseBtn:AddAnchor("CENTER", softCCIntValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(softCCIntIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    softCCIntIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.softCCIntensity = (settings.softCCIntensity + 0.1)
        else
            settings.softCCIntensity = (settings.softCCIntensity + 0.01)
        end
        if settings.softCCIntensity > 1 then settings.softCCIntensity = 1 end
        softCCIntValuelbl:SetText(tostring(settings.softCCIntensity)) 
    end)

    local softCCIntDecreaseBtn = wnd:CreateChildWidget("button", "softCCIntDecreaseBtn", 0, true)
    softCCIntDecreaseBtn:SetExtent(20, 20)
    softCCIntDecreaseBtn:SetText("<")
    softCCIntDecreaseBtn:AddAnchor("CENTER", softCCIntValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(softCCIntDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    softCCIntDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.softCCIntensity = (settings.softCCIntensity - 0.1)
        else
            settings.softCCIntensity = (settings.softCCIntensity - 0.01)
        end
        if settings.softCCIntensity < 0 then settings.softCCIntensity = 0 end
        softCCIntValuelbl:SetText(tostring(settings.softCCIntensity)) 
    end)


    -- Save button
    local saveBtn = wnd:CreateChildWidget("button", "saveBtn", 0, true)
    saveBtn:SetExtent(90, 26)
    saveBtn:SetText("Save")
    saveBtn:AddAnchor("BOTTOM", wnd, 0, -14)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(saveBtn, BUTTON_BASIC.DEFAULT)
    end
    saveBtn:SetHandler("OnClick", function() vibe.save_settings(settings) reloadFn(settings) wnd:Show(false) end)

	wnd:Show(true)
end

function M.Save()
    if settings then
        vibe.save_settings(settings)
    end
end

function M.Unload()
	if wnd then
		wnd:Show(false)
		wnd = nil
	end
end

return M
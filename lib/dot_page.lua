local api = require("api")
local vibe = require("auto_vibrator/vibe_writer")

local M = {}
local wnd
local settings = vibe.get_secondary_settings()

function M.Open(reloadFn)
	wnd = api.Interface:CreateWindow("aav-pop", "Dot Settings")
	wnd:SetExtent(300, 550)
	wnd:Show(false)

	local infolbl = wnd:CreateChildWidget("label", "infolbl", 0, true)
	infolbl:SetText("Hold shift to increase increments")
	infolbl.style:SetAlign(ALIGN.CENTER)
    infolbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    infolbl.style:SetColor(0.400, 0.251, 0.043, 1)
    infolbl:AddAnchor("TOP", wnd, 0, 40)

	-- Intensity
	local intensitylbl = wnd:CreateChildWidget("label", "intensitylabel", 0, true)
	intensitylbl:SetText("Value for max intensity")
	intensitylbl.style:SetAlign(ALIGN.CENTER)
    intensitylbl.style:SetFontSize(FONT_SIZE.LARGE)
    intensitylbl.style:SetColor(0.400, 0.251, 0.043, 1)
    intensitylbl:AddAnchor("TOP", wnd, 0, 80)

    local intValuelbl = wnd:CreateChildWidget("label", "intValuelbl", 0, true)
    intValuelbl:SetText(tostring(settings.maxIntensityDOT))
    intValuelbl.style:SetAlign(ALIGN.CENTER)
    intValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    intValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    intValuelbl:AddAnchor("TOP", intensitylbl, 0, 30)

	local intIncreaseBtn = wnd:CreateChildWidget("button", "intIncreaseBtn", 0, true)
    intIncreaseBtn:SetExtent(20, 20)
    intIncreaseBtn:SetText(">")
    intIncreaseBtn:AddAnchor("CENTER", intValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(intIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    intIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.maxIntensityDOT = (settings.maxIntensityDOT + 1000)
        else
            settings.maxIntensityDOT = (settings.maxIntensityDOT + 100)
        end
        intValuelbl:SetText(tostring(settings.maxIntensityDOT)) 
    end)

    local intDecreaseBtn = wnd:CreateChildWidget("button", "intDecreaseBtn", 0, true)
    intDecreaseBtn:SetExtent(20, 20)
    intDecreaseBtn:SetText("<")
    intDecreaseBtn:AddAnchor("CENTER", intValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(intDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    intDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.maxIntensityDOT = (settings.maxIntensityDOT - 1000)
        else
            settings.maxIntensityDOT = (settings.maxIntensityDOT - 100)
        end
        if settings.maxIntensityDOT < 0 then settings.maxIntensityDOT = 0 end
        intValuelbl:SetText(tostring(settings.maxIntensityDOT)) 
    end)

    -- Duration
    local durationlbl = wnd:CreateChildWidget("label", "durationlabel", 0, true)
	durationlbl:SetText("Value for max duration")
	durationlbl.style:SetAlign(ALIGN.CENTER)
    durationlbl.style:SetFontSize(FONT_SIZE.LARGE)
    durationlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    durationlbl:AddAnchor("TOP", wnd, 0, 160)

    local durValuelbl = wnd:CreateChildWidget("label", "durValuelbl", 0, true)
    durValuelbl:SetText(tostring(settings.maxDurationDOT))
    durValuelbl.style:SetAlign(ALIGN.CENTER)
    durValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    durValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    durValuelbl:AddAnchor("TOP", durationlbl, 0, 30)

	local durIncreaseBtn = wnd:CreateChildWidget("button", "durIncreaseBtn", 0, true)
    durIncreaseBtn:SetExtent(20, 20)
    durIncreaseBtn:SetText(">")
    durIncreaseBtn:AddAnchor("CENTER", durValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(durIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    durIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.maxDurationDOT = (settings.maxDurationDOT + 1000)
        else
            settings.maxDurationDOT = (settings.maxDurationDOT + 100)
        end
        durValuelbl:SetText(tostring(settings.maxDurationDOT)) 
    end)

    local durDecreaseBtn = wnd:CreateChildWidget("button", "durDecreaseBtn", 0, true)
    durDecreaseBtn:SetExtent(20, 20)
    durDecreaseBtn:SetText("<")
    durDecreaseBtn:AddAnchor("CENTER", durValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(durDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    durDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.maxDurationDOT = (settings.maxDurationDOT - 1000)
        else
            settings.maxDurationDOT = (settings.maxDurationDOT - 100)
        end
        if settings.maxDurationDOT < 0 then settings.maxDurationDOT = 0 end
        durValuelbl:SetText(tostring(settings.maxDurationDOT)) 
    end)

    -- Max Duration
    local maxDurationlbl = wnd:CreateChildWidget("label", "maxDurationlbl", 0, true)
	maxDurationlbl:SetText("Max duration caused by dot in Ms")
	maxDurationlbl.style:SetAlign(ALIGN.CENTER)
    maxDurationlbl.style:SetFontSize(FONT_SIZE.LARGE)
    maxDurationlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    maxDurationlbl:AddAnchor("TOP", wnd, 0, 240)

    local maxDurValuelbl = wnd:CreateChildWidget("label", "maxDurValuelbl", 0, true)
    maxDurValuelbl:SetText(tostring(settings.maxDOTDurationMs))
    maxDurValuelbl.style:SetAlign(ALIGN.CENTER)
    maxDurValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    maxDurValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    maxDurValuelbl:AddAnchor("TOP", maxDurationlbl, 0, 30)

	local maxDurIncreaseBtn = wnd:CreateChildWidget("button", "maxDurIncreaseBtn", 0, true)
    maxDurIncreaseBtn:SetExtent(20, 20)
    maxDurIncreaseBtn:SetText(">")
    maxDurIncreaseBtn:AddAnchor("CENTER", maxDurValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(maxDurIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    maxDurIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.maxDOTDurationMs = (settings.maxDOTDurationMs + 1000)
        else
            settings.maxDOTDurationMs = (settings.maxDOTDurationMs + 100)
        end
        maxDurValuelbl:SetText(tostring(settings.maxDOTDurationMs)) 
    end)

    local maxDurDecreaseBtn = wnd:CreateChildWidget("button", "maxDurDecreaseBtn", 0, true)
    maxDurDecreaseBtn:SetExtent(20, 20)
    maxDurDecreaseBtn:SetText("<")
    maxDurDecreaseBtn:AddAnchor("CENTER", maxDurValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(maxDurDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    maxDurDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.maxDOTDurationMs = (settings.maxDOTDurationMs - 1000)
        else
            settings.maxDOTDurationMs = (settings.maxDOTDurationMs - 100)
        end
        if settings.maxDOTDurationMs < 0 then settings.maxDOTDurationMs = 0 end
        maxDurValuelbl:SetText(tostring(settings.maxDOTDurationMs)) 
    end)

    -- Modifier info
    local modInfolbl = wnd:CreateChildWidget("label", "modInfolbl", 0, true)
	modInfolbl:SetText("Assign multipliers. Default = 1")
	modInfolbl.style:SetAlign(ALIGN.CENTER)
    modInfolbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    modInfolbl.style:SetColor(0.400, 0.251, 0.043, 1)
    modInfolbl:AddAnchor("TOP", wnd, 0, 335)

    -- Outgoing Mod
    local modOutlbl = wnd:CreateChildWidget("label", "modOutlbl", 0, true)
	modOutlbl:SetText("Outgoing DOT Multiplier")
	modOutlbl.style:SetAlign(ALIGN.CENTER)
    modOutlbl.style:SetFontSize(FONT_SIZE.LARGE)
    modOutlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    modOutlbl:AddAnchor("TOP", wnd, 0, 360)

    local modOutValuelbl = wnd:CreateChildWidget("label", "modOutValuelbl", 0, true)
    modOutValuelbl:SetText(tostring(settings.healingOutMod))
    modOutValuelbl.style:SetAlign(ALIGN.CENTER)
    modOutValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    modOutValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    modOutValuelbl:AddAnchor("TOP", modOutlbl, 0, 30)

	local modOutIncreaseBtn = wnd:CreateChildWidget("button", "modOutIncreaseBtn", 0, true)
    modOutIncreaseBtn:SetExtent(20, 20)
    modOutIncreaseBtn:SetText(">")
    modOutIncreaseBtn:AddAnchor("CENTER", modOutValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(modOutIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    modOutIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.healingOutMod = (settings.healingOutMod + 0.1)
        else
            settings.healingOutMod = (settings.healingOutMod + 0.01)
        end
        modOutValuelbl:SetText(tostring(settings.healingOutMod)) 
    end)

    local modOutDecreaseBtn = wnd:CreateChildWidget("button", "modOutDecreaseBtn", 0, true)
    modOutDecreaseBtn:SetExtent(20, 20)
    modOutDecreaseBtn:SetText("<")
    modOutDecreaseBtn:AddAnchor("CENTER", modOutValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(modOutDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    modOutDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.healingOutMod = (settings.healingOutMod - 0.1)
        else
            settings.healingOutMod = (settings.healingOutMod - 0.01)
        end
        if settings.healingOutMod < 0.01 then settings.healingOutMod = 0 end
        modOutValuelbl:SetText(tostring(settings.healingOutMod)) 
    end)

    -- Incoming Mod
    local modInlbl = wnd:CreateChildWidget("label", "modInlbl", 0, true)
	modInlbl:SetText("Incoming DOT Multiplier")
	modInlbl.style:SetAlign(ALIGN.CENTER)
    modInlbl.style:SetFontSize(FONT_SIZE.LARGE)
    modInlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    modInlbl:AddAnchor("TOP", wnd, 0, 440)

    local modInValuelbl = wnd:CreateChildWidget("label", "modInValuelbl", 0, true)
    modInValuelbl:SetText(tostring(settings.healingInMod))
    modInValuelbl.style:SetAlign(ALIGN.CENTER)
    modInValuelbl.style:SetFontSize(FONT_SIZE.MEDIUM)
    modInValuelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    modInValuelbl:AddAnchor("TOP", modInlbl, 0, 30)

	local modInIncreaseBtn = wnd:CreateChildWidget("button", "modInIncreaseBtn", 0, true)
    modInIncreaseBtn:SetExtent(20, 20)
    modInIncreaseBtn:SetText(">")
    modInIncreaseBtn:AddAnchor("CENTER", modInValuelbl, 80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(modInIncreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    modInIncreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.healingInMod = (settings.healingInMod + 0.1)
        else
            settings.healingInMod = (settings.healingInMod + 0.01)
        end
        modInValuelbl:SetText(tostring(settings.healingInMod)) 
    end)

    local modInDecreaseBtn = wnd:CreateChildWidget("button", "modInDecreaseBtn", 0, true)
    modInDecreaseBtn:SetExtent(20, 20)
    modInDecreaseBtn:SetText("<")
    modInDecreaseBtn:AddAnchor("CENTER", modInValuelbl, -80, 0)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(modInDecreaseBtn, BUTTON_BASIC.DEFAULT)
    end
    modInDecreaseBtn:SetHandler("OnClick", function(_, button) 
        if api.Input:IsShiftKeyDown() then
            settings.healingInMod = (settings.healingInMod - 0.1)
        else
            settings.healingInMod = (settings.healingInMod - 0.01)
        end
        if settings.healingInMod < 0.01 then settings.healingInMod = 0 end
        modInValuelbl:SetText(tostring(settings.healingInMod)) 
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
local api = require("api")
local vibe = require("auto_vibrator/vibe_writer")
local CreateCheckButton = require("auto_vibrator/lib/check_button")
local healing_page = require("auto_vibrator/lib/healing_page")
local damage_page = require("auto_vibrator/lib/damage_page")
local dot_page = require("auto_vibrator/lib/dot_page")
local config_page = require("auto_vibrator/lib/config_page")
local misc_page = require("auto_vibrator/lib/misc_page")


local function SendTestVibe()
    api.Log:Info("Sending Vibe At 50% for 1 second")
	local ok, err = vibe.send_vibe(0.5, 1000)
	if not ok then
		if err == "%%%%%" then
			api.Log:Err("Previous input not handled. Is the companion app running?")
        else
            api.Log:Err("Send Vibe Failed: " .. err)
		end
	else
		api.Log:Info("Vibe Sent Successfully")
	end
end

function SendStopVibe()
	api.Log:Info("Sending Stop Vibe")
	vibe.send_stop()
end

local M = {}
local wnd = nil
local pop = nil

local function load_pop(type, fn)
    if pop ~= nil then
        pop.Unload()
    end
    
    if type == "config" then
        pop = config_page
        pop.Open()
    elseif type == "healing" then
        pop = healing_page
        pop.Open(fn)
    elseif type == "damage" then
        pop = damage_page
        pop.Open(fn)
    elseif type == "dot" then
        pop = dot_page
        pop.Open(fn)
    elseif type == "misc" then
        pop = misc_page
        pop.Open(fn)
    else
        api.Log:Err("Unknown pop type")
    end
end 

function M.Open(reloadFn)
  local settings = vibe.get_primary_settings()
  if not wnd then
    -- Create window
    -- TODO: Implement tabs?
    -- TODO: Save window pos
    wnd = api.Interface:CreateWindow("aavibrator", "Archeage Vibrations Settings")
    wnd:SetExtent(600, 350)
    wnd:Show(false)

    -- Companion info
    local companionlbl = wnd:CreateChildWidget("label", "companionlbl", 0, true)
    companionlbl:SetText("This addon requires it's companion app and intiface central!")
    companionlbl.style:SetAlign(ALIGN.CENTER)
    companionlbl.style:SetFontSize(FONT_SIZE.SMALL)
    companionlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    companionlbl:AddAnchor("TOP", wnd, 0, 40)

    -- Activators
    local activatelbl = wnd:CreateChildWidget("label", "activeLabel", 0, true)
    activatelbl:SetText("Set Vibration Activators")
    activatelbl.style:SetAlign(ALIGN.CENTER)
    activatelbl.style:SetFontSize(FONT_SIZE.LARGE)
    activatelbl.style:SetColor(0.400, 0.251, 0.043, 1)
    activatelbl:AddAnchor("TOP", wnd, -150, 60)

    local cb_enabled = CreateCheckButton("cb_enabled", wnd, "Vibrations Enabled")
    cb_enabled:AddAnchor("TOP", activatelbl, -60, 20)
    cb_enabled:SetChecked(settings.active)
    cb_enabled.CheckBtnCheckChangedProc = function(_, checked)
        settings.active = not settings.active
    end
    
    local cb_healout = CreateCheckButton("cb_healout", wnd, "Outgoing Healing")
    cb_healout:AddAnchor("TOP", activatelbl, -60, 40)
    cb_healout:SetChecked(settings.activateOnHealingOut)
    cb_healout.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnHealingOut = not settings.activateOnHealingOut
    end
    
    local cb_healin = CreateCheckButton("cb_healin", wnd, "Incoming Healing")
    cb_healin:AddAnchor("TOP", activatelbl, -60, 60)
    cb_healin:SetChecked(settings.activateOnHealingIn)
    cb_healin.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnHealingIn = not settings.activateOnHealingIn
    end
    
    local cb_damout = CreateCheckButton("cb_damout", wnd, "Outgoing Damage")
    cb_damout:AddAnchor("TOP", activatelbl, -60, 80)
    cb_damout:SetChecked(settings.activateOnDamageOut)
    cb_damout.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnDamageOut = not settings.activateOnDamageOut
    end
    
    local cb_damin = CreateCheckButton("cb_damin", wnd, "Incoming Damage")
    cb_damin:AddAnchor("TOP", activatelbl, -60, 100)
    cb_damin:SetChecked(settings.activateOnDamageIn)
    cb_damin.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnDamageIn = not settings.activateOnDamageIn
    end
    
    local cb_dotout = CreateCheckButton("cb_dotout", wnd, "Outgoing Dot")
    cb_dotout:AddAnchor("TOP", activatelbl, -60, 120)
    cb_dotout:SetChecked(settings.activateOnDOTOut)
    cb_dotout.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnDOTOut = not settings.activateOnDOTOut
    end

    local cb_dotin = CreateCheckButton("cb_dotin", wnd, "Incoming Dot")
    cb_dotin:AddAnchor("TOP", activatelbl, -60, 140)
    cb_dotin:SetChecked(settings.activateOnDOTIn)
    cb_dotin.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnDOTIn = not settings.activateOnDOTIn
    end

    local cb_respawn = CreateCheckButton("cb_respawn", wnd, "Stop Vibe On Respawn")
    cb_respawn:AddAnchor("TOP", activatelbl, 0, 160)
    cb_respawn:SetChecked(settings.stopOnRespawn)
    cb_respawn.CheckBtnCheckChangedProc = function(_, checked)
        settings.stopOnRespawn = not settings.stopOnRespawn
    end
    if not settings.activateOnDeath then cb_respawn:Show(false) end

    local cb_death = CreateCheckButton("cb_death", wnd, "Death")
    cb_death:AddAnchor("TOP", activatelbl, -60, 160)
    cb_death:SetChecked(settings.activateOnDeath)
    cb_death.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnDeath = not settings.activateOnDeath
        cb_respawn:Show(settings.activateOnDeath)
    end

    local cb_cc = CreateCheckButton("cb_cc", wnd, "Crowd Control")
    cb_cc:AddAnchor("TOP", activatelbl, -60, 180)
    cb_cc:SetChecked(settings.activateOnCC)
    cb_cc.CheckBtnCheckChangedProc = function(_, checked)
        settings.activateOnCC = not settings.activateOnCC
    end

    -- Panels
    local panelsMainlbl = wnd:CreateChildWidget("label", "panelsMainlbl", 0, true)
    panelsMainlbl:SetText("Change Specific Values")
    panelsMainlbl.style:SetAlign(ALIGN.CENTER)
    panelsMainlbl.style:SetFontSize(FONT_SIZE.LARGE)
    panelsMainlbl.style:SetColor(0.400, 0.251, 0.043, 1)
    panelsMainlbl:AddAnchor("TOP", wnd, 150, 60)

    local healingPanelBtn = wnd:CreateChildWidget("button", "healingPanelBtn", 0, true)
    healingPanelBtn:SetExtent(90, 26)
    healingPanelBtn:SetText("Open Healing Panel")
    healingPanelBtn:AddAnchor("BOTTOM", panelsMainlbl, 0, 60)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(healingPanelBtn, BUTTON_BASIC.DEFAULT)
    end
    healingPanelBtn:SetHandler("OnClick", function() load_pop("healing", reloadFn) end)

    local damagePanelBtn = wnd:CreateChildWidget("button", "damagePanelBtn", 0, true)
    damagePanelBtn:SetExtent(90, 26)
    damagePanelBtn:SetText("Open Damage Panel")
    damagePanelBtn:AddAnchor("BOTTOM", panelsMainlbl, 0, 110)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(damagePanelBtn, BUTTON_BASIC.DEFAULT)
    end
    damagePanelBtn:SetHandler("OnClick", function() load_pop("damage", reloadFn) end)

    local dotPanelBtn = wnd:CreateChildWidget("button", "dotPanelBtn", 0, true)
    dotPanelBtn:SetExtent(90, 26)
    dotPanelBtn:SetText("Open Dot Panel")
    dotPanelBtn:AddAnchor("BOTTOM", panelsMainlbl, 0, 160)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(dotPanelBtn, BUTTON_BASIC.DEFAULT)
    end
    dotPanelBtn:SetHandler("OnClick", function() load_pop("dot", reloadFn) end)

    local miscPanelBtn = wnd:CreateChildWidget("button", "miscPanelBtn", 0, true)
    miscPanelBtn:SetExtent(90, 26)
    miscPanelBtn:SetText("Open Misc Panel")
    miscPanelBtn:AddAnchor("BOTTOM", panelsMainlbl, 0, 210)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(miscPanelBtn, BUTTON_BASIC.DEFAULT)
    end
    miscPanelBtn:SetHandler("OnClick", function() load_pop("misc", reloadFn) end)
    
    -- Save button
    local saveBtn = wnd:CreateChildWidget("button", "saveBtn", 0, true)
    saveBtn:SetExtent(90, 26)
    saveBtn:SetText("Save")
    saveBtn:AddAnchor("BOTTOM", wnd, 200, -14)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(saveBtn, BUTTON_BASIC.DEFAULT)
    end
    saveBtn:SetHandler("OnClick", function() vibe.save_settings(settings) 
    if pop ~= nil then pop.Save() pop.Unload() pop = nil end
    reloadFn(settings) wnd:Show(false) end)

    -- Open config window button -- Stub
    local openConfigBtn = wnd:CreateChildWidget("button", "openConfigBtn", 0, true)
    openConfigBtn:SetExtent(90, 26)
    openConfigBtn:SetText("Open Config")
    openConfigBtn:AddAnchor("BOTTOM", wnd, -200, -14)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(openConfigBtn, BUTTON_BASIC.DEFAULT)
    end
    openConfigBtn:SetHandler("OnClick", function() load_pop("config", nil) end)

    -- Test vibe button
    local testVibeBtn = wnd:CreateChildWidget("button", "testVibeBtn", 0, true)
    testVibeBtn:SetExtent(90, 26)
    testVibeBtn:SetText("Test Vibe")
    testVibeBtn:AddAnchor("BOTTOM", wnd, -50, -14)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(testVibeBtn, BUTTON_BASIC.DEFAULT)
    end
    testVibeBtn:SetHandler("OnClick", function() SendTestVibe() end)

    -- Stop vibe button
    local stopVibeBtn = wnd:CreateChildWidget("button", "stopVibeBtn", 0, true)
    stopVibeBtn:SetExtent(90, 26)
    stopVibeBtn:SetText("Stop Vibe")
    stopVibeBtn:AddAnchor("BOTTOM", wnd, 50, -14)
    if api.Interface.ApplyButtonSkin then
      api.Interface:ApplyButtonSkin(stopVibeBtn, BUTTON_BASIC.DEFAULT)
    end
    stopVibeBtn:SetHandler("OnClick", function() SendStopVibe() end)

  end

  wnd:Show(true)
end

function M.Unload()
    if pop then
        pop:Unload()
        pop = nil
    end
    if wnd then
        -- Save window pos
        local x, y = wnd:GetOffset()
        vibe.save_settings({sp_x = x, sp_y = y})

        wnd:Show(false)
        wnd = nil
    end

    
end

return M

local api = require("api")
local vibe = require("auto_vibrator/vibe_writer")
local hardCCList, softCCList = require("auto_vibrator/lib/cc_list")

local auto_vibrator = {
	name = "AutoVibrator",
	author = "Emi",
	version = "1.2",
	desc = "Vibrations based on ingame events"
}

local handler = nil
local hasDied = false
local seen = {}

-------------------------------------------------
-- Settings
-------------------------------------------------
local settings = vibe.load_settings_or_default()
local settings_page = nil

local function reload_settings()
	local s = vibe.load_settings_or_default()
	for k, v in pairs(s) do 
		settings[k] = v
	end

	if settings.activateOnDeath then
		ADDON:RegisterContentTriggerFunc(UIC.DEATH_AND_RESURRECTION_WND, OnRespawnWindow)
	else
		ADDON:RegisterContentTriggerFunc(UIC.DEATH_AND_RESURRECTION_WND, nil)
	end
end

-------------------------------------------------
-- Vibe Handler
-------------------------------------------------

local function clamp(x, a, b)
    return math.max(a, math.min(b, x))
end

local function map_damage(dmg, modifier)
	local mod = tonumber(modifier) or 1
	local amount = math.abs(dmg)

    -- Base mappings
    local intensity = clamp(amount / settings.maxIntensityDamage, 0, 1)
    local duration = clamp((amount / settings.maxDurationDamage) * settings.maxDamageDurationMs, 0, settings.maxDamageDurationMs)

	-- Apply modifier
	intensity = clamp(intensity * mod, 0, 1)
	duration = clamp(duration * mod, 0, settings.maxDamageDurationMs)

    return intensity, duration
end

local function map_healing(healing, modifier)
	local mod = tonumber(modifier) or 1
	local amount = math.abs(healing)

	-- Base mappings
	local intensity = clamp(amount / settings.maxIntensityHealing, 0, 1)
	local duration = clamp((amount / settings.maxDurationHealing) * settings.maxHealingDurationMs, 0, settings.maxHealingDurationMs)

	-- Apply modifiers
	intensity = clamp(intensity * mod, 0, 1)
	duration = clamp(duration * mod, 0, settings.maxHealingDurationMs)

	return intensity, duration
end

local function map_dot(dmg, modifier)
	local mod = tonumber(modifier) or 1
	local amount = math.abs(dmg)

    -- Base mappings
    local intensity = clamp(amount / settings.maxIntensityDOT, 0, 1)
    local duration = clamp((amount / settings.maxDurationDOT) * settings.maxDOTDurationMs, 0, settings.maxDOTDurationMs)

	-- Apply modifier
	intensity = clamp(intensity * mod, 0, 1)
	duration = clamp(duration * mod, 0, settings.maxDOTDurationMs)

    return intensity, duration
end

local function SendVibe(intensity, duration)
	if not settings.active then return end
	if intensity == 0 or intensity < 0 or duration == 0 or duration < 0 then return end

	--api.Log:Info("Sending vibe with Intensity: " .. tostring(intensity) .. " and Duration: " .. tostring(duration))
	local ok, err = vibe.send_vibe(intensity, duration)
	if not ok then
		if err == "%%%%%" then
			api.Log:Info("Deferring Input. Not Yet Processed")
		end
		api.Log:Info("Send Vibe Failed: " .. err)
	end
end

local function SendStopVibe()
	api.Log:Info("Sending Stop Vibe")
	vibe.send_stop()
end

-------------------------------------------------
-- Combat Event Handlers
-------------------------------------------------
local function getPlayerId()
	local playerId = api.Unit:GetUnitId("player")
	return playerId
end

local function onCombatText(sourceId, targetId, amount, skillType, hitOrMissType, weaponDamage, isSynergy, distance)
	local playerId = getPlayerId()
	if sourceId == playerId then
		-- Player is source > Outgoing
		if (skillType == "SKILL" or skillType == "SWING") and settings.activateOnDamageOut then
			local i, d = map_damage(amount, settings.damageOutMod)
			SendVibe(i, d)
		elseif skillType == "DOT" and settings.activateOnDOTOut then
			local i, d = map_dot(amount, settings.dotOutMod)
			SendVibe(i, d)
		elseif skillType == "HEAL" and settings.activateOnHealingOut then
			local i, d = map_healing(amount, settings.healingOutMod)
			SendVibe(i, d)
		end
	elseif targetId == playerId then
		-- Player is target > Incoming
		if (skillType == "SKILL" or skillType == "SWING") and settings.activateOnDamageIn then
			local i, d = map_damage(amount, settings.damageInMod)
			SendVibe(i, d)
		elseif skillType == "DOT" and settings.activateOnDOTIn then
			local i, d = map_dot(amount, settings.dotInMod)
			SendVibe(i, d)
		elseif skillType == "HEAL" and settings.activateOnHealingIn then
			local i, d = map_healing(amount, settings.healingInMod)
			SendVibe(i, d)
		end
	end
end

local function onCombatMsg(targetId, combatEvent, source, target, ...)
	local playerId = getPlayerId()
	if targetId == playerId then
		if (combatEvent == "SPELL_DAMAGE" or combatEvent == "MELEE_DAMAGE") and settings.activateOnDamageIn then
			local result = ParseCombatMessage(combatEvent, unpack(arg))
			local i, d = map_damage(result.damage, settings.damageInMod)
			SendVibe(i, d)
		elseif combatEvent == "SPELL_DOT_DAMAGE" and settings.activateOnDOTIn then
			local result = ParseCombatMessage(combatEvent, unpack(arg))
			local i, d = map_dot(result.damage, settings.dotInMod)
			SendVibe(i, d)
		end
	elseif source == playerId then
		if (combatEvent == "SPELL_DAMAGE" or combatEvent == "MELEE_DAMAGE") and settings.activateOnDamageOut then
			local result = ParseCombatMessage(combatEvent, unpack(args))
			local i, d = map_damage(result.damage, settings.damageOutMod)
			SendVibe(i, d)
		elseif combatEvent == "SPELL_DOT_DAMAGE" and settings.activateOnDOTOut then
			local result = ParseCombatMessage(combatEvent, unpack(args))
			local i, d = map_dot(result.damage, settings.dotOutMod)
			SendVibe(i, d)
		end
	end
end

-------------------------------------------------
-- Game event handlers
-------------------------------------------------

local function OnLoad()
	-- Create window to catch events
	handler = api.Interface:CreateEmptyWindow("combatlogger", "UIParent")
	handler:SetHandler("OnEvent", function(self, event, ...)
		if event == "COMBAT_TEXT" then
			onCombatText(unpack(arg))
		elseif event == "COMBAT_MSG" then
			onCombatMsg(unpack(arg))
		end
	end)
	
	-- Hook into events
	handler:RegisterEvent("COMBAT_TEXT")
	handler:RegisterEvent("COMBAT_MSG")

	if settings.activateOnDeath then
		ADDON:RegisterContentTriggerFunc(UIC.DEATH_AND_RESURRECTION_WND, OnRespawnWindow)
	end
end

local function OnUnload()
	if settings_page ~= nil then
		settings_page:Unload()
		settings_page = nil
	end
	if handler ~= nil then
		handler:Show(false)
		handler = nil
	end
	api.On("UPDATE", nil)
end

local function OnSettingToggle()
	settings_page = require("auto_vibrator/settings_page")
	if settings_page then
		settings_page.Open(reload_settings)
	else
		api.Log:Err("VB: Failed to open settings page")
	end
end

-- CC Helpers
local function IsCCDebuff(name)
	for _, ccName in ipairs(hardCCList) do
		if string.lower(name) == string.lower(ccName) then
			return true, false
		end
	end

	for _, ccName in ipairs(softCCList) do
		if string.lower(name) == string.lower(ccName) then
			return false, true
		end
	end

	return false, false
end

local function nowMs()
  return (api.Time and api.Time.GetUiMsec and api.Time:GetUiMsec()) or 0
end
--

local function OnUpdate()
	if not settings.active then return end

	-- Handle death event
	local hp = api.Unit:UnitHealth("player")
	if hp <= 0 and not hasDied then
		hasDied = true
		if settings.activateOnDeath then
			api.Log:Info("Seen Death")
			SendVibe(settings.deathIntensity, settings.deathDuration)
		end
	elseif hasDied and hp > 0 then
		hasDied = false
		if settings.stopOnRespawn then
			SendStopVibe()
		end
	end

	-- Handle cc event
	local now = api.Time:GetUiMsec()

	if settings.activateOnCC then
		local count = api.Unit:UnitDeBuffCount("player") or 0
		if count > 0 then
			for i = 1, count do
				local debuff = api.Unit:UnitDeBuff("player", i)
				if debuff and debuff.buff_id then
					local expireAt = now + debuff.timeLeft
					local key = debuff.buff_id .. ":" .. tostring(expireAt)	

					if not seen[key] then
						local tooltip = api.Ability.GetBuffTooltip(debuff.buff_id, debuff.buff_id)
						if tooltip then
							local isHard, isSoft = IsCCDebuff(tooltip.name)
							if isHard then
								seen[key] = {expireAt = expireAt}
								SendVibe(settings.hardCCIntensity, debuff.timeLeft)
							elseif isSoft then
								seen[key] = {expireAt = expireAt}
								SendVibe(settings.softCCIntensity, debuff.timeLeft)
							end
						end
					end
				end
			end
		end
	end

	-- Cleanup
	for k, v in pairs(seen) do
		if v.expireAt < now then
			seen[key] = nil
		end
	end
end

api.On("UPDATE", OnUpdate)

auto_vibrator.OnLoad = OnLoad
auto_vibrator.OnUnload = OnUnload
auto_vibrator.OnSettingToggle = OnSettingToggle

return auto_vibrator
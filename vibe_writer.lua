local api = require("api")
local M = {}

-- Paths
M.output_path = "auto_vibrator/aac-av-mailbox.txt"
M.settings_path = "auto_vibrator/aac-av-settings.txt"

local function pad4(n) return string.format("%04d", (math.tointeger(n) or math.floor(n)) % 10000) end

function M.send_vibe(intensity, duration_ms)
	if type(intensity) ~= "number" or type(duration_ms) ~= "number" then
        return false, "intensity and duration_ms must be numbers"
    end

	-- Clamp intensity
	if intensity < 0 then intensity = 0 end
	if intensity > 1 then intensity = 1 end

	-- Handle Integers
	local pct = math.floor(intensity * 100 + 0.5)
	duration_ms = math.floor(duration_ms)

    local msg = "VIBE|" .. intensity .. "|" .. duration_ms

	-- Check file contents
    local existing = api.File:Read(M.output_path)
    if existing and type(existing) == "string" and existing:match("%S") then
        -- file exists and is not empty
        return false, "%%%%%"
    end

	api.File:Write(M.output_path, msg)

	return true, ""
end

function M.send_stop()
	-- Ensure the file exists before writing
    if existing == nil then
        api.File:Write(M.output_path, {})
    end

    local msg = "STOP|"
    api.File:Write(M.output_path, msg)
    return true, ""
end

function M.send_config(text)
    -- Ensure the file exists before writing
    if existing == nil then
        api.File:Write(M.output_path, {})
    end

    local msg = "CONF|"
    if type(text) == "string" then
        msg = msg .. text .. "|"
    else
        msg = table.concat(text, "|")
    end

    api.File:Write(M.output_path, msg)
    return true
end

local function escape_string(s)
    s = s:gsub("\\", "\\\\")
         :gsub("\n", "\\n")
         :gsub("\t", "\\t")
         :gsub("\r", "\\r")
         :gsub("\"", "\\\"")
    return s
end

local function unescape_string(s)
    s = s:gsub("\\n", "\n")
         :gsub("\\t", "\t")
         :gsub("\\r", "\r")
         :gsub("\\\"", "\"")
         :gsub("\\\\", "\\")
    return s
end

local function serialize_settings_kv(tbl)
    local keys = {}
    for k in pairs(tbl) do
        if type(k) ~= "string" then
            error("Only string keys are supported: got " .. tostring(k))
        end
        keys[#keys+1] = k
    end
    table.sort(keys)

    local out = {}
    for _, k in ipairs(keys) do
        local v = tbl[k]
        local vs
        local tv = type(v)
        if tv == "string" then
            vs = '"' .. escape_string(v) .. '"'
        elseif tv == "number" then
            vs = tostring(v)
        elseif tv == "boolean" then
            vs = tostring(v)
        else
            error("Unsupported value type for key " .. k .. ": " .. tv)
        end
        out[#out+1] = string.format("%s = %s", k, vs)
    end
    return table.concat(out, "\n") .. "\n"
end

local function parse_settings_kv(text)
    local t = {}
    local s = tostring(text or "")

    s = s .. "\n"
    for line in s:gmatch("([^\r\n]*)\r?\n") do
        local trimmed = line:match("^%s*(.-)%s*$")

        if trimmed ~= "" and not trimmed:match("^#") and not trimmed:match("^;") and not trimmed:match("^%-%-") then
            local key, val = trimmed:match("^([^=]+)=(.+)$")
            if key then
                key = key:match("^%s*(.-)%s*$")
                val = val:match("^%s*(.-)%s*$")

                -- booleans
                if val == "true" then
                    t[key] = true
                elseif val == "false" then
                    t[key] = false
                else
                    -- number?
                    local num = tonumber(val)
                    if num ~= nil then
                        t[key] = num
                    else
                        -- quoted string?
                        local q = val:match('^"(.*)"$')
                        if q ~= nil then
                            t[key] = unescape_string(q)
                        else
                            -- bareword -> string
                            t[key] = val
                        end
                    end
                end
            end
        end
    end

    return t
end

function M.load_settings_or_default()
    local settings_text = api.File:Read(M.settings_path)
    local settings = {}
    
    local DEFAULT_SETTINGS = {
	active = true,
	activateOnHealingOut = true,
	activateOnHealingIn = true,
	activateOnDamageOut = true,
	activateOnDamageIn = true,
	activateOnDOTOut = true,
	activateOnDOTIn = true,
    activateOnDeath = true,
    activateOnCC = true,
    stopOnRespawn = false,
	healingOutMod = 1,
	healingInMod = 1,
	damageOutMod = 1,
	damageInMod = 1,
	dotOutMod = 1,
	dotInMod = 1,
    deathIntensity = 1,
    deathDuration = 5000,
    hardCCIntensity = 1,
    softCCIntensity = 0.2,
	maxIntensityHealing = 10000,
	maxDurationHealing = 20000,
	maxHealingDurationMs = 5000,
	maxIntensityDamage = 10000,
	maxDurationDamage = 20000,
	maxDamageDurationMs = 5000,
    maxIntensityDOT = 700,
    maxDurationDOT = 1000,
    maxDOTDurationMs = 500,
    sp_x = 0,
    sp_y = 0,
    }

    if type(settings_text) == "string" and settings_text ~= "" then
        local ok, parsed = pcall(parse_settings_kv, settings_text)
        if ok and type(parsed) == "table" then
            settings = parsed
        end
    end

    for k,v in pairs(DEFAULT_SETTINGS) do
        if settings[k] == nil then
            settings[k] = v
        end
    end

    return settings
end

function M.get_primary_settings()
    local settings = M.load_settings_or_default()

    local primary_settings = {}
    for k, v in pairs(settings) do
        if type(v) == "boolean" then
            primary_settings[k] = v
        end
    end

    return primary_settings
end

function M.get_secondary_settings()
    local settings = M.load_settings_or_default()

    local secondary_settings = {}
    for k, v in pairs(settings) do
        if type(v) == "boolean" then
        else
            secondary_settings[k] = v
        end
    end
    
    return secondary_settings
end

function M.save_settings(tbl)
    local saved = M.load_settings_or_default()

    for k, v in pairs(tbl) do
        saved[k] = v
    end

    local text = serialize_settings_kv(saved)

    api.File:Write(M.settings_path, text)
end


return M
-- YAML file schema (all fields optional):
--
--   whitelisted_models:       # lowercase mesh stem names
--     - goblin01
--
--   blacklisted_models:       # lowercase mesh stems - always overrides whitelisted_models
--     - undeadwolf_2

local types  = require("openmw.types")
local vfs    = require("openmw.vfs")
local markup = require("openmw.markup")
require("scripts.Bullseye.utils.utils") -- provides ExtractFileName()

-- ──────────────────────────────────────────────────────────────────────────────
-- Config loading
-- ──────────────────────────────────────────────────────────────────────────────

local CONFIG_PREFIX = "scripts/Bullseye/config/"

local whitelistedCreatureTypes = {
    [types.Creature.TYPE.Daedra]   = true,
    [types.Creature.TYPE.Undead]   = true,
    [types.Creature.TYPE.Humanoid] = true,
}
local whitelistedModels = {} -- [lowercase stem] = true
local blacklistedModels = {} -- [lowercase stem] = true

local function loadConfig()
    local loaded = 0
    for filePath in vfs.pathsWithPrefix(CONFIG_PREFIX) do
        if filePath:match("%.yaml$") or filePath:match("%.yml$") then
            local ok, data = pcall(markup.loadYaml, filePath)
            if not ok then
                print("[Bullseye] WARNING: could not parse " .. filePath .. ": " .. tostring(data))
            else
                if type(data.whitelisted_models) == "table" then
                    for _, v in ipairs(data.whitelisted_models) do
                        whitelistedModels[v:lower()] = true
                    end
                end

                if type(data.blacklisted_models) == "table" then
                    for _, v in ipairs(data.blacklisted_models) do
                        blacklistedModels[v:lower()] = true
                    end
                end

                loaded = loaded + 1
                print("[Bullseye] Loaded config: " .. filePath)
            end
        end
    end

    if loaded == 0 then
        print("[Bullseye] WARNING: no config YAMLs found under " .. CONFIG_PREFIX)
    end
end

loadConfig()

-- ──────────────────────────────────────────────────────────────────────────────
-- Headshot logic
-- ──────────────────────────────────────────────────────────────────────────────

local function headshottable(victim)
    if types.NPC.objectIsInstance(victim) then
        return true
    end

    local victimRecord = victim.type.records[victim.recordId]

    if victimRecord.canUseWeapons then
        return true
    end

    local stem = ExtractFileName(victimRecord.model):lower()

    if blacklistedModels[stem] then
        return false
    end

    if whitelistedCreatureTypes[victimRecord.type] then
        return true
    end

    return whitelistedModels[stem] or false
end

function HeadshotSuccessful(victim, attackPos)
    if not headshottable(victim) then return false end

    local headShotLevel = .85

    -- Bounding-box approach from Ranged Headshot mod by SkyHasCats
    -- https://modding-openmw.gitlab.io/ranged-headshot/
    local bbox = victim:getBoundingBox()
    local half = bbox.halfSize
    local center = bbox.center

    local rel = attackPos - center
    local normalizedHeight = (rel.z + half.z) / (2 * half.z)

    return normalizedHeight > headShotLevel
end

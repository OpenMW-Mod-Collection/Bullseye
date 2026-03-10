local types = require("openmw.types")

require("scripts.Bullseye.utils.utils")

local whitelistedCreatureTypes = {
    [types.Creature.TYPE.Humanoid] = true,
    [types.Creature.TYPE.Daedra]   = true,
    [types.Creature.TYPE.Undead]   = true,
}

local whitelistedModels = {
    -- vanilla
    ["almalexia"]         = true,
    ["almalexia_warrior"] = true,
    ["byagram"]           = true,
    ["cr_draugr"]         = true,
    ["draugrLord"]        = true,
    ["frostgiant"]        = true,
    ["goblin01"]          = true,
    ["goblin02"]          = true,
    ["goblin03"]          = true,
    ["golden saint"]      = true,
    ["ice troll"]         = true,
    ["iceminion"]         = true,
    ["icemraider"]        = true,
    ["kwama warrior"]     = true,
    ["lordvivec"]         = true,
    ["sphere_centurions"] = true,
    ["spherearcher"]      = true,
    ["spriggan"]          = true,
    ["steam_centurions"]  = true,
    ["udyrfrykte"]        = true,
    ["skinnpc"]           = true, -- werewolf
}

local blacklistedModels = {
    -- vanilla
    ["undeadwolf_2"] = true,
}

local function headshottable(victim)
    if types.NPC.objectIsInstance(victim) then
        return true
    end

    local victimRecord = victim.type.records[victim.recordId]
    if blacklistedModels[ExtractFileName(victimRecord.model)] then
        return false
    end

    if whitelistedCreatureTypes[victimRecord.type] then
        return true
    end

    return whitelistedModels[ExtractFileName(victimRecord.model)]
end

function HeadshotSuccessful(victim, attackPos)
    if not headshottable(victim) then return false end

    -- bor: might not be super accurate for creatures, but idc
    local headShotLevel = .85
    -- code from Ranged Headshot mod by SkyHasCats
    -- https://modding-openmw.gitlab.io/ranged-headshot/
    local bbox = victim:getBoundingBox()
    local half = bbox.halfSize
    local center = bbox.center
    -- Local hit position relative to center
    local rel = attackPos - center
    -- Convert to 0..1 along vertical axis
    -- bottom = -half.z, top = +half.z
    local normalizedHeight = (rel.z + half.z) / (2 * half.z)
    -- print(string.format("Hit height ratio: %.2f", normalizedHeight))
    return normalizedHeight > headShotLevel
end

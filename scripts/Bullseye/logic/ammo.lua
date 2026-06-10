---@diagnostic disable: param-type-mismatch
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local storage = require("openmw.storage")
local types = require("openmw.types")
local async = require("openmw.async")

local settingsCache = require("scripts.Bullseye.utils.settingsCache")

local settingsAmmoRetrieval = settingsCache.new(storage.globalSection("SettingsBullseye_ammoRetrieval"), async)

function AmmoHandler(attack)
    if not attack.successful
        or attack.sourceType ~= I.Combat.ATTACK_SOURCE_TYPES.Ranged
        or not attack.ammo
    then
        return
    end

    local ammoRecord = types.Weapon.records[attack.ammo]
    local retrieveEnchanted = settingsAmmoRetrieval.retrieveEnchantedProjectiles
    local isThrown = attack.weapon.id == "@0x0"
        -- HOW THE FUCK
        or attack.weapon.type.records[attack.weapon.recordId].type == attack.weapon.type.TYPE.MarksmanThrown
    local retrievalChance = isThrown
        and settingsAmmoRetrieval.thrownRetrievalChance
        or settingsAmmoRetrieval.ammoRetrievalChance

    if math.random() > retrievalChance
        or (not retrieveEnchanted and ammoRecord.enchant)
    then
        return
    end

    core.sendGlobalEvent("Bullseye_retrieveAmmo", {
        actor = self,
        itemRecordId = attack.ammo
    })
end
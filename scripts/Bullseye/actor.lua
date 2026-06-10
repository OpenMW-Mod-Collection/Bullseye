---@diagnostic disable: param-type-mismatch
local I = require("openmw.interfaces")
local types = require("openmw.types")
local self = require("openmw.self")
local storage = require("openmw.storage")
local async = require("openmw.async")

require("scripts.Bullseye.logic.headshots")
require("scripts.Bullseye.logic.ammo")
local settingsCache = require("scripts.Bullseye.utils.settingsCache")

local settingsDamageMult = settingsCache.new(storage.globalSection("SettingsBullseye_damageMult"), async)

local function getDistanceModifier(distance)
    local maxDist = settingsDamageMult.defaultDmgMaxDistance
    local minDist = settingsDamageMult.defaultDmgMinDistance

    if minDist <= distance and distance < maxDist then
        return 0
    elseif distance < minDist then
        return -1 * (minDist - distance) / 1000 * settingsDamageMult.distanceDamageFalloff
    elseif maxDist <= distance then
        return (distance - maxDist) / 1000 * settingsDamageMult.distanceDamageBuildup
    end
end

local function hitHandler(attack)
    if not attack.successful
        or attack.sourceType ~= I.Combat.ATTACK_SOURCE_TYPES.Ranged
        or attack.attacker.type ~= types.Player
        or attack.damage.health == 0
        or attack.ngarde_perfectParry
    then
        return
    end

    local isThrown = attack.weapon.id == "@0x0"
        -- HOW THE FUCK
        or types.Weapon.records[attack.weapon.recordId].type == types.Weapon.TYPE.MarksmanThrown
    local distance = (attack.attacker.position - self.position):length()
    local distMod = isThrown and 0 or getDistanceModifier(distance)

    local headMod = HeadshotSuccessful(self, attack.hitPos)
        and settingsDamageMult.headshotMultiplier
        or 0

    local damageModifier = settingsDamageMult.baseMult + distMod + headMod
    damageModifier = math.max(settingsDamageMult.minTotalMult, damageModifier)
    damageModifier = math.min(settingsDamageMult.maxTotalMult, damageModifier)

    if settingsDamageMult.showMultMessage then
        local headshotLine = headMod == 0
            and "" or string.format("\nHeadshot mult: %.2fx", headMod)

        attack.attacker:sendEvent("ShowMessage", {
            message = string.format(
                "[Bullseye]" ..
                "\nShot distance: %d units" ..
                "\nDistance mult: %.2fx" ..
                headshotLine ..
                "\nFinal damage mult: %.2f",
                distance, distMod, damageModifier
            )
        })
    end

    local headshotVolume = settingsDamageMult.playHeadshotSFX
    if headMod ~= 0 and headshotVolume ~= 0 then
        attack.attacker:sendEvent("Bullseye_PlayHeadshotSFX", headshotVolume)
    end

    attack.damage.health = attack.damage.health * damageModifier
    attack.attacker:sendEvent("Bullseye_hit", damageModifier)
end

I.Combat.addOnHitHandler(AmmoHandler)
I.Combat.addOnHitHandler(hitHandler)

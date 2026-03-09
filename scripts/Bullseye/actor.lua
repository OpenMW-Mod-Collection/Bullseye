local I = require("openmw.interfaces")
local types = require("openmw.types")
local self = require("openmw.self")

require("scripts.Bullseye.logic.headshots")

local function retrieveAmmo(item, chance)
    if math.random() > chance then return end

    -- enchanted ammo cannot be recovered
    local itemRecord = item.type.records[item.recordId]
    local retrieveEnchantedAmmo = false
    if not retrieveEnchantedAmmo and itemRecord.enchant then return end

    item:moveInto(self)
end

local function getDistanceModifier(playerPos)
    local distance = (playerPos - self.position):length()
    local maxDist = 3000
    local minDist = 800

    if minDist <= distance < maxDist then
        return 0
    elseif distance < minDist then
        return distance / 1000 * .25
    elseif maxDist <= distance then
        return distance / 1000 * .25 * (-1)
    end
end

local function hitHandler(attack)
    if not attack.successful
        or attack.sourceType ~= I.Combat.ATTACK_SOURCE_TYPES.Ranged
        or attack.attacker.type ~= types.Player
    then
        return
    end

    local weaponRecord = attack.weapon.type.records[attack.weapon.recordId]
    local isThrown = weaponRecord.type == types.Weapon.TYPE.MarksmanThrown

    local ammoToRetrieve = isThrown and attack.weapon or attack.ammo
    local retrievalChance = isThrown and .25 or .75
    retrieveAmmo(ammoToRetrieve, retrievalChance)

    local distMod = isThrown and 0 or getDistanceModifier(attack.attacker.position)
    local headMod = HeadshotSuccessful(self, attack.hitPos) and .5 or 0
    local damageModifier = 1 + distMod + headMod
    damageModifier = math.max(.5, damageModifier)
    damageModifier = math.min(3, damageModifier)

    attack.damage = attack.damage * damageModifier
end

I.Combat.addOnHitHandler(hitHandler)

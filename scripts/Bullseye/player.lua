local self = require("openmw.self")
local I = require("openmw.interfaces")
local time = require("openmw_aux.time")
local storage = require("openmw.storage")
local ambient = require("openmw.ambient")

require("scripts.Bullseye.logic.ammo")

local sectionPlayerStats = storage.globalSection("SettingsBullseye_playerStats")
local sectionFatigue = storage.globalSection("SettingsBullseye_fatigue")

MovementStatuses = {
    idling   = "idling",
    moving   = "moving",
    sneaking = "sneaking",
}

local latestMovementStatus = MovementStatuses.idling
local currMovementStatus = MovementStatuses.idling
local currentAnimState = nil
local bowHeld = false
local fatigueRates = {
    bowDraw = "bowDrawFatigueDrainRate",
    bowHold = "bowHoldFatigueDrainRate",
    crossbow = "crossbowFatigueDrainRate",
    thrown = "thrownFatigueDrainRate",
}

local movementEffect = {
    [MovementStatuses.idling] = function() end,
    [MovementStatuses.moving] = function(marksman, direction)
        local debuff = sectionPlayerStats:get("movementDebuff")

        -- when returning back, capping restoration to not give any buffs
        if direction == -1 then
            debuff = math.min(marksman.damage, debuff)
            debuff = math.max(0, debuff)
        end

        marksman.modifier = marksman.modifier
            - debuff
            * direction
    end,
    [MovementStatuses.sneaking] = function(marksman, direction)
        marksman.modifier = marksman.modifier
            + sectionPlayerStats:get("sneakBuff")
            * direction
    end,
}

local function updateMovementEffect()
    local stance       = self.type.getStance(self)
    local weaponStance = stance == self.type.STANCE.Weapon
    local weapon       = self.type.getEquipment(self, self.type.EQUIPMENT_SLOT.CarriedRight)

    if not weaponStance
        or not weapon
        or currMovementStatus == MovementStatuses.idling
    then
        return
    end

    local weaponType = weapon.type.records[weapon.recordId].type
    local eqBow      = weaponType == weapon.type.TYPE.MarksmanBow
    local eqCrossbow = weaponType == weapon.type.TYPE.MarksmanCrossbow
    if not (eqBow or eqCrossbow) then return end

    local isMoving     = self.type.getCurrentSpeed(self) ~= 0 and weaponStance
    local isSneaking   = self.controls.sneak and weaponStance
    local marksman     = self.type.stats.skills.marksman(self)

    currMovementStatus = (isSneaking and MovementStatuses.sneaking)
        or (isMoving and MovementStatuses.moving)
        or MovementStatuses.idling

    if latestMovementStatus ~= currMovementStatus then
        movementEffect[latestMovementStatus](marksman, -1)
        latestMovementStatus = currMovementStatus
        movementEffect[currMovementStatus](marksman, 1)
    end
end

local function drainFatigue(dt, amount)
    local fatigue = self.type.stats.dynamic.fatigue(self)
    local drain = fatigue.current - amount * dt
    fatigue.current = math.max(0, drain)
end

local function onUpdate(dt)
    updateMovementEffect()

    local rateKey = fatigueRates[currentAnimState]
    if rateKey then
        drainFatigue(dt, sectionFatigue:get(rateKey))
    end
end

local function onSave()
    return {
        latestMovementStatus = latestMovementStatus,
        currMovementStatus = currMovementStatus,
    }
end

local function onLoad(saveData)
    latestMovementStatus = saveData.latestMovementStatus
    currMovementStatus = saveData.currMovementStatus
end

local function playHeadshotSFX(volume)
    ambient.playSound("critical damage", {
        volume = volume
    })
end

local bowstringHeldTooLongCallback = time.registerTimerCallback(
    "bowstringHeldTooLong",
    function()
        if bowHeld and currentAnimState == nil then
            currentAnimState = "bowHold"
        end
    end
)

I.AnimationController.addTextKeyHandler("bowandarrow", function(_, key)
    if key == "shoot attach" then
        currentAnimState = "bowDraw"
    elseif key == "shoot max attack" then
        currentAnimState = nil
        bowHeld = true

        time.newSimulationTimer(
            sectionFatigue:get("bowFatigueDrainDelay"),
            bowstringHeldTooLongCallback
        )
    elseif key == "shoot min hit" or key == "unequip start" then
        currentAnimState = nil
        bowHeld = false
    end
end)

I.AnimationController.addTextKeyHandler("crossbow", function(_, key)
    if key == "shoot release" then
        currentAnimState = "crossbow"
    elseif key == "shoot follow stop" then
        currentAnimState = nil
    end
end)

I.AnimationController.addTextKeyHandler("throwweapon", function(_, key)
    if key == "shoot min hit" then
        currentAnimState = "thrown"
    elseif key == "shoot follow stop" then
        currentAnimState = nil
    end
end)

I.Combat.addOnHitHandler(AmmoHandler)

return {
    engineHandlers = {
        onUpdate = onUpdate,
        onSave = onSave,
        onLoad = onLoad,
    },
    eventHandlers = {
        Bullseye_PlayHeadshotSFX = playHeadshotSFX
    }
}

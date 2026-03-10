local self = require("openmw.self")
local I = require("openmw.interfaces")
local time = require("openmw_aux.time")
local storage = require("openmw.storage")

local sectionPlayer = storage.globalSection("SettingsBullseye_player")

MovementStatuses = {
    idling   = "idling",
    moving   = "moving",
    sneaking = "sneaking",
}

local movementEffect = {
    [MovementStatuses.idling] = function() end,
    [MovementStatuses.moving] = function(marksman, direction)
        marksman.modifier = marksman.modifier
            - sectionPlayer:get("movementDebuff")
            * direction
    end,
    [MovementStatuses.sneaking] = function(marksman, direction)
        marksman.modifier = marksman.modifier
            + sectionPlayer:get("sneakBuff")
            * direction
    end,
}

local latestMovementStatus = MovementStatuses.idling
local currMovementStatus = MovementStatuses.idling
local bowstringHeld = false
local bowstringHeldTooLong = false
local reloadingCrossbow = false

local function updateMovementEffect()
    local stance       = self.type.getStance(self)
    local weaponStance = stance == self.type.STANCE.Weapon
    if not weaponStance then return end

    local weapon     = self.type.getEquipment(self, self.type.EQUIPMENT_SLOT.CarriedRight)
    local weaponType = weapon.type.records[weapon.recordId].type
    local eqBow      = weaponType == weapon.type.TYPE.MarksmanBow
    local eqCrossbow = weaponType == weapon.type.TYPE.MarksmanCrossbow
    if not (eqBow or eqCrossbow) then return end

    local isMoving     = self.type.getCurrentSpeed(self) ~= 0
    local isSneaking   = self.controls.sneak
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

local function drainFatigueBowstring(dt)
    local fatigue = self.type.stats.dynamic.fatigue(self)
    fatigue.current = math.max(0,
        fatigue.current - sectionPlayer:get("bowFatigueDrainRate") * dt)
end

local function drainFatigueReload(dt)
    local fatigue = self.type.stats.dynamic.fatigue(self)
    fatigue.current = math.max(0,
        fatigue.current - sectionPlayer:get("crossbowFatigueDrainRate") * dt)
end

local function onUpdate(dt)
    updateMovementEffect()
    if bowstringHeldTooLong then
        drainFatigueBowstring(dt)
    elseif reloadingCrossbow then
        drainFatigueReload(dt)
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

local bowstringHeldTooLongCallback = time.registerTimerCallback("bowstringHeldTooLong", function()
    bowstringHeldTooLong = bowstringHeld
end)

I.AnimationController.addTextKeyHandler("bowandarrow", function(groupname, key)
    if key == "shoot max attack" then
        bowstringHeld = true
        time.newGameTimer(
            sectionPlayer:get("bowFatigueDrainDelay"),
            bowstringHeldTooLongCallback)
    elseif key == "shoot min hit" or key == "unequip start" then
        bowstringHeld = false
        bowstringHeldTooLong = false
    end
end)

I.AnimationController.addTextKeyHandler("crossbow", function(groupname, key)
    if key == "shoot release" then
        reloadingCrossbow = true
    elseif key == "shoot follow stop" then
        reloadingCrossbow = false
    end
end)

return {
    engineHandlers = {
        onUpdate = onUpdate,
        onSave = onSave,
        onLoad = onLoad,
    }
}

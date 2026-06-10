local world = require("openmw.world")
local types = require("openmw.types")
local storage = require("openmw.storage")

local sectionNearHit = storage.globalSection("SettingsBullseye_nearHit")

local function retrieveAmmo(eventData)
    local ammoItem = world.createObject(eventData.itemRecordId, 1)
    ---@diagnostic disable-next-line: discard-returns
    ammoItem:moveInto(eventData.actor)
end

local function arrowLanded(eventData)
    local aggroEnabled = sectionNearHit:get("nearHitAggroEnabled")
    if not aggroEnabled then return end

    local arrowPos = eventData.position
    for _, actor in ipairs(world.activeActors) do
        local distance = (actor.position - arrowPos):length()
        if distance > sectionNearHit:get("aggroDistance")
            or actor.type.isDead(actor)
            or not actor:isValid()
            or types.Player.objectIsInstance(actor)
            -- https://en.uesp.net/wiki/Morrowind:NPCs#Fight
            or actor.type.stats.ai.fight(actor) < 83
        then
            goto continue
        end

        actor:sendEvent("StartAIPackage", { type = "Combat", target = eventData.actor })

        ::continue::
    end
end

return {
    eventHandlers = {
        Bullseye_retrieveAmmo = retrieveAmmo,
        -- requires Arrow Stick mod to work
        ArrowStick_PlaceNewArrow = arrowLanded,
    }
}

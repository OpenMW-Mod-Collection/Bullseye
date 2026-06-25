---@diagnostic disable: param-type-mismatch
local world = require("openmw.world")
local types = require("openmw.types")
local storage = require("openmw.storage")
local async = require("openmw.async")

local settingsCache = require("scripts.Bullseye.utils.settingsCache")
require("scripts.Bullseye.headshotConfig.parser")

local settingsNearHit = settingsCache.new(storage.globalSection("SettingsBullseye_nearHit"), async)
local actorScript = "scripts/Bullseye/actor.lua"

local function onActorActive(actor)
    if types.Player.objectIsInstance(actor)
        or actor:hasScript(actorScript)
    then
        return
    end

    actor:addScript(actorScript, { headshottable = Headshottable(actor) })
end

local function retrieveAmmo(eventData)
    local ammoItem = world.createObject(eventData.itemRecordId, 1)
    ---@diagnostic disable-next-line: discard-returns
    ammoItem:moveInto(eventData.actor)
end

local function arrowLanded(eventData)
    local aggroEnabled = settingsNearHit.nearHitAggroEnabled
    if not aggroEnabled then return end

    local arrowPos = eventData.position
    for _, actor in ipairs(world.activeActors) do
        local distance = (actor.position - arrowPos):length()
        if distance > settingsNearHit.aggroDistance
            or actor.type.isDead(actor)
            or not actor:isValid()
            or types.Player.objectIsInstance(actor)
            -- https://en.uesp.net/wiki/Morrowind:NPCs#Fight
            or actor.type.stats.ai.fight(actor).modified < 83
        then
            goto continue
        end

        actor:sendEvent("StartAIPackage", { type = "Combat", target = eventData.actor })

        ::continue::
    end
end

return {
    engineHandlers = {
        onActorActive = onActorActive,
    },
    eventHandlers = {
        Bullseye_retrieveAmmo = retrieveAmmo,
        -- requires Arrow Stick mod to work
        ArrowStick_PlaceNewArrow = arrowLanded,
    }
}

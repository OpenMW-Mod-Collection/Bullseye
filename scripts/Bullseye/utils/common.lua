local core = require("openmw.core")

function RetrieveAmmo(actor, itemRecord, chance, retrieveEnchanted)
    if math.random() > chance
        or (not retrieveEnchanted and itemRecord.enchant)
    then
        return
    end

    core.sendGlobalEvent("Bullseye_retrieveAmmo", {
        actor = actor,
        itemRecordId = itemRecord.id
    })
end

local I = require("openmw.interfaces")

local function ignoreAttack(attack)
    
end

local function hitHandler(attack)
    if ignoreAttack(attack) then return end
end

I.Combat.addOnHitHandler(hitHandler)
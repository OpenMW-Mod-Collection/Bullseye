local I = require("openmw.interfaces")

I.Settings.registerGroup {
    key = 'SettingsBullseye_hitChance',
    page = 'Bullseye',
    l10n = 'Bullseye',
    name = 'hitChance_groupName',
    permanentStorage = true,
    order  = 1,
    settings = {
        {
            key = 'movementDebuff',
            name = 'movementDebuff_name',
            renderer = 'number',
            default = 10,
            min = 0,
        },
        {
            key = 'sneakBuff',
            name = 'sneakBuff_name',
            renderer = 'number',
            default = 20,
            min = 0,
        },
        {
            key = 'fatigueDrainRate',
            name = 'fatigueDrainRate_name',
            renderer = 'number',
            default = 20,
            min = 0,
        },
        {
            key = 'badWeatherDebuff',
            name = 'badWeatherDebuff_name',
            renderer = 'number',
            default = 20,
            min = 0,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsBullseye_damage',
    page = 'Bullseye',
    l10n = 'Bullseye',
    name = 'damage_groupName',
    permanentStorage = true,
    order = 2,
    settings = {
        {
            key = 'distance',
            name = 'distance_name',
            renderer = 'number',
            default = 1,
            min = 0,
        },
        {
            key = 'distanceRange',
            name = 'distanceRange_name',
            renderer = 'number',
            default = 1,
            min = 0,
        },
        {
            key = 'distanceDamageBuildup',
            name = 'istanceDamageBuildup_name',
            renderer = 'number',
            default = 1,
            min = 0,
        },
        {
            key = 'distanceDamageFalloff',
            name = 'distanceDamageFalloff_name',
            renderer = 'number',
            default = 1,
            min = 0,
        },
        {
            key  = 'headshotMultiplier',
            name = 'headshotMultiplier_name',
            renderer = 'number',
            default = 1.5,
            min = 0,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsBullseye_debug',
    page = 'Bullseye',
    l10n = 'Bullseye',
    name = 'debug_groupName',
    permanentStorage = true,
    order = 100,
    settings = {
        {
            key = 'enableMessages',
            name = 'enableMessages_name',
            renderer = 'checkbox',
            default = true,
        },
    }
}

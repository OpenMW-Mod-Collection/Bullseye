# Bullseye - Marksman Overhaul (OpenMW)

Marksman combat shouldn't feel like melee with extra reach.

_Spiritual successor of my [Headshots](https://www.nexusmods.com/morrowind/mods/57406) mod._

Archers should control the battlefield through positioning and distance, while warriors should dominate close combat. Your goal is simple: keep your distance and land your shots.

## Feature List

### Lua Mechanics

**Combat Mechanics** _(affects only the player)_

- Damage multiplier based on attack distance _(does not affect thrown weapons)_
- Headshot damage multiplier
- Marksman debuff while moving
- Marksman buff while sneaking

**Fatigue System** _(affects only the player)_

- Bows drain fatigue when drawing the bowstring
- Bows drain fatigue when holding the bowstring too long
- Crossbows drain fatigue when reloading
- Throwing weapons drain fatigue when they are thrown

**Ammo Economy Rebalance**

- Custom chance for ammunition to stick into the victim
  - Bows / Crossbows - 25%
  - Thrown weapons - 75%

**AI Behavior** _(optional, requires [Arrow Stick](https://www.nexusmods.com/morrowind/mods/58299))_

- Missed arrows can alert nearby hostile NPCs

And, of course, every value is configurable.

### GMST Edits

**Faster Marksman Projectiles**

- fProjectileMinSpeed: 400 -> 1000
- fProjectileMaxSpeed: 3000 -> 8000
- fThrownWeaponMinSpeed: 300 -> 1000
- fThrownWeaponMaxSpeed: 1000 -> 4000

**Ammo Economy Rebalance** _(since it is replaced with Lua)_

- fProjectileThrownStoreChance: 25 -> 0

## Feature Details

### Headshots

A headshot counts if an actor is hit within the top 85% of their bounding box. Not every creature can be headshot, but most humanoid-looking actors can, including:

- NPCs
- Creatures that can wield weapons
- Humanoid creatures
- Daedra
- Undead
- Everyone else who is manually whitelisted

The detection list is mostly dynamic, so some modded creatures might produce false positives from time to time. If you notice something missing, feel free to report it.

## Compatibility

Safe to install, update, or delete mid-playthrough.

Compatible with any mods.

If there is a mod in your modlist that affects the `fProjectileThrownStoreChance` GMST, `BullseyeGMSTs.omwaddon` needs to be loaded after it. While it is not critical, you might experience ammo duplication in corpses. TL;DR: load `BullseyeGMSTs.omwaddon` after any combat-affecting mods or simply last.

### Soft Incompatibilities

- [Headshots](https://www.nexusmods.com/morrowind/mods/57406) by me - Already implemented here
- [Sneak Attack Buff (OpenMW Lua)](https://www.nexusmods.com/morrowind/mods/52352) by Solthas - Bullseye penalizes for bowstring holding and SAB rewards. Though, it can be changed in settings
- [Projectile Overhaul - Modular](https://www.nexusmods.com/morrowind/mods/43195) by Mr.Magic - "Faster Projectiles" and "Recovery Chance" modules will override the GMST changes made by Bullseye if loaded after the Bullseye. Same goes for the merged version

### Requirements

- [Arrow Stick](https://www.nexusmods.com/morrowind/mods/58299) 1.5 or newer - Optional, load order doesn't matter

### Supported Mods (Headshot Whitelist)

- [Tamriel_Data](https://www.nexusmods.com/morrowind/mods/44537) by PTR Team
- [OAAB_Data](https://www.nexusmods.com/morrowind/mods/49042) by OAAB_Data Team

### Recommendations

- [Arrow Stick](https://www.nexusmods.com/morrowind/mods/58299) by me and DaisyHasACat
- [Sneak Fatigue Drain (OpenMW)](https://www.nexusmods.com/morrowind/mods/58433) by me
- [Ammo Count HUD (OpenMW)](https://www.nexusmods.com/morrowind/mods/58307) by me
- [Sneak is Good Now. -- OpenMW](https://www.nexusmods.com/morrowind/mods/58441) by Max Yari
- [Crossbows Enhanced](https://www.nexusmods.com/morrowind/mods/48586) by Alaisiagae and WHReaper
- [Smart Ammo for OpenMW-Lua](https://www.nexusmods.com/morrowind/mods/51274) by johnnyhostile
- [Take Cover (OpenMW)](https://www.nexusmods.com/morrowind/mods/54976) by mym
- [Cast onStrike Bow and Crossbow (openMW)](https://www.nexusmods.com/morrowind/mods/57329) by ComeBESNIER
- [UNCALCULATED LEVELED CREATURES FIX AND YOU CAN ACTUALLY GET ENCHANTED ARROWS AFTER LEVEL 5](https://www.nexusmods.com/morrowind/mods/51717) by concit
- [Enchanter's Quiver - Arrows and Projectiles Enchant Capacity](https://www.nexusmods.com/morrowind/mods/58121) by 6moonless
- [Hawk3ye - OpenMW Zooming](https://www.nexusmods.com/morrowind/mods/57125) by S3ctor / [Marksman's Eye](https://www.nexusmods.com/morrowind/mods/51141) by johnnyhostile / [Bow Aim Activate (OpenMW Lua)](https://www.nexusmods.com/morrowind/mods/52332) by Solthas

## Credits

**Sosnoviy Bor** - Author  
**DaisyHasACat** - Logic behind headshots and initial inspiration ([Ranged Headshot](https://modding-openmw.gitlab.io/ranged-headshot/))  
**Axemagister** - Inspiration ([N'wah Shooter](https://www.nexusmods.com/morrowind/mods/49657))  
**Merlord** - Inspiration ([Realistic Archery](https://www.nexusmods.com/morrowind/mods/51473))  
**Cybvep** - Help with creature headshot whitelist
**Oreman** - Chinese translation

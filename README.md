# Bullseye - Marksman Overhaul (OpenMW)

Marksman combat shouldn't feel like melee with extra reach.

*Spiritual successor of my [Headshots](https://www.nexusmods.com/morrowind/mods/57406) mod.*

Archers control the battlefield through **positioning and distance**, while warriors dominate close combat. This mod shifts the focus of ranged combat away from character stats and toward **player skill and positioning**.

Your goal is simple: **keep your distance and land your shots.**

## Feature List

### Lua Mechanics

All Lua changes affect **the player only**.

**Combat Mechanics**
- Damage multiplier based on attack distance *(does not affect thrown weapons)*
- Headshot damage multiplier
- Marksman debuff while moving
- Marksman buff while sneaking

**Fatigue System**
- Bows drain fatigue when holding the bowstring too long
- Crossbows drain fatigue when reloading

**Ammo Economy Rebalance**
- Custom chance for ammunition to stick into the victim
  - Bows / Crossbows - **25%**
  - Thrown weapons - **75%**

**AI Behavior** *(optional, requires Arrow Stick)*
- Missed arrows can alert nearby hostile NPCs
- Missed arrows can turn a non-hostile NPCs hostile

**GMST Edits**
- asd

Every value is configurable.

## Core Mechanics

Now for the thought process.

### Distance Matters

Your distance from the target now directly affects **bow and crossbow damage**.

The further away you are (within reason), the more effective your shots become. Closing the gap will reduce their effectiveness.

This encourages you to:
- find good firing positions
- maintain distance
- control enemy approach

Thrown weapons are **not affected** by this mechanic, making them a reliable **mid-range backup** when enemies get too close.

### Headshots

Precision is now rewarded.

Hits to the **upper 85% of an actor's bounding box** count as headshots and grant a **flat damage multiplier bonus**.

Headshots work with any marksman weapon.

Not every creature can be headshot, but most humanoid-looking actors can, including:

- NPCs
- humanoid creatures
- daedra
- undead
- several supported creature types

The detection list is mostly dynamic, so some modded creatures might raise false-positives here and there. If you notice something missing, feel free to report it.

### Awareness and Positioning

Marksmen should behave like marksmen.

- Running while shooting makes it **harder to land shots**
- Sneaking provides **combat benefits**
- Missing a shot can now **alert nearby NPCs**

A careless arrow might reveal your position - even to non-hostile actors.

## Compatibility

Safe to install, update or delete mid-playthrough.

Compatible with any mods.

### Soft Incompatibilities

- [Headshots](https://www.nexusmods.com/morrowind/mods/57406) by me - Already implemented here

### Requirements

- [Arrow Stick](https://www.nexusmods.com/morrowind/mods/58299) by me and DaisyHasACat - Optional, but recommended

## My Archery Gameplay Setup

- asd

## Credits

**Sosnoviy Bor** - Author  
**DaisyHasACat** - Logic behind headshots and initial inspiration ([Ranged Headshot](https://modding-openmw.gitlab.io/ranged-headshot/))  
**Axemagister** - Inspiration ([N'wah Shooter](https://www.nexusmods.com/morrowind/mods/49657))  
**Merlord** - Inspiration ([Realistic Archery](https://www.nexusmods.com/morrowind/mods/51473))  

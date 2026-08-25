# The Pat Project - Project Overview

> Short 3D first-person on-rails WWII tank ride. Always moving. Click to shoot.
> Next work is the tank rail itself.

## Problem

The product is a short, somber on-rails shooter: you sit in a tank that never
stops, rolling farm and hedges into trenches into a ruined town, and you click
to shoot.

A grey-box canoe fight and river clicks already exist in the repo. They are a
prior experiment. Do not keep the canoe as the main scene once the tank ride
exists.

## Users

- **You (now)** - play in the Godot editor and build the tank ride.
- **You, then a friend (later)** - Windows zip if export stays simple. No
  accounts or access tiers.
- Not a live service, web game, or Steam store page in this pass.

## Features

Headline for `/feature`: **12. Tank rail ride**. Items 1 and 2 are complete and
superseded. Do not spec cover stands or other dropped items.

1. **Canoe native fight** (done, superseded) - grey-box river rail, natives, spears, 3 HP restart
2. **River clicks** (done, superseded) - hover-click props on the canoe; teaching object
12. **Tank rail ride** - locked first-person camera on a tank that always moves; POLYGON WAR countryside into trenches into a ruined town; small HP readout; no combat yet
13. **Click-to-shoot** - mouse-left reticle hitscan on the moving tank; click is always shoot
14. **Soldiers and slow shots** - soldiers fire readable projectiles; shoot the shot or the shooter; three hits reload the whole ride
15. **Flavor shootables** - barrels, crates, or signs react to a shot (mostly audio)
16. **Boss stretch** - denser fight on the same moving rail in the town or at a bunker
17. **Windows download** - export a Windows zip if it stays simple; skip or defer if export becomes a project

Not in this MVP: cover / duck / still rooms, continues, silent secrets, puzzles,
extra branches, canoe-as-product.

## Data model

Nothing is persisted to disk. In-run state only.

### TankRun (target for features 12-16)

Reuse the canoe health rules on the tank scene. Do not add continues.

- `health` (int) - starts at 3; each projectile hit subtracts 1
- `is_alive` (bool) - false when health reaches 0
- `needs_restart` (bool) - true after a fatal fail; full tank-ride reload clears it

### Soldier (feature 14)

- `is_alive` (bool) - false after a successful hitscan on this shooter
- Fires slow, visible projectiles while alive and on-screen

### SlowProjectile (feature 14)

- In-flight, readable war object (grenade, panzerfaust, mortar). Not a tiny
  bullet. Destroyed if shot. Each player hit subtracts 1 health.

### FlavorShootable (feature 15)

- Shot with the same hitscan as combat. Plays audio or a small world reaction.
  Not a second input action. No inventory pickup.

### Canoe leftovers (do not extend)

`CanoeRun`, `Native`, `Spear`, and `Interactable` exist in the current canoe
scenes. Treat them as the old experiment. Feature 12 replaces the product ride.
Do not add `spared_natives`, `has_idol`, `current_section`, or
`continues_remaining`.

## Tech stack

- **Godot 4** - engine (`config_version=5`; editor reported 4.7)
- **GDScript (typed)** - gameplay
- **3D rail** - locked first-person camera, always moving, no free look
- **Reticle + click-to-shoot** - one action, `shoot` (mouse left)
- **`assets/POLYGON WAR/`** - WWII pack library; search by name, do not dump
  the pack into context
- **Main scene today:** `res://scenes/canoe.tscn` until feature 12 ships a tank
  ride and points `project.godot` at it
- **Editor Play (F5)** - how we verify; no test runner yet

## Monetization

Not in this project. Hobby / send-a-build.

## UI/UX

Somber WWII ground war. Slow tank. Methodical, not chaotic. Click to shoot.
Small HP readout. Hover may tint the reticle on a valid shot target. No cover
prompt, no inventory, no continue screen.

- `res://scenes/canoe.tscn` - leftover experiment (still the main scene)
- Tank ride scene - named in feature 12; becomes the main scene

## Deployment

- **Now:** Godot editor. No export required for items 12-16.
- **Item 17:** Windows executable, zip, send a link, only if export stays
  simple. If it fights the project, stay editor-only.
- Repo: `DaveEstey/the-pat-project-v2`
- No Render/Vercel, no server, no env vars, no database.

## Open questions

- Exact projectile (grenade vs panzerfaust vs mortar) is an example list, not
  locked. Feature 14 should pick one readable object.
- Tank ride scene path is not named yet (`res://scenes/tank.tscn` is a likely
  default for feature 12).
- Hover tint is optional ("may tint"), not a required HUD system.
- Item 17 may be skipped if Windows export becomes its own project. That is
  already allowed by the build plan.

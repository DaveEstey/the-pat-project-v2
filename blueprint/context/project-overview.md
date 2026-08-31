# The Pat Project - Project Overview

> Short 3D first-person on-rails WWII tank ride. Always moving. Click to shoot.

## Problem

The product is a short, somber on-rails shooter: you sit in a tank that never
stops, rolling farm and hedges into trenches into a ruined town, then turning
into a bunker approach, and you click to shoot.

A grey-box canoe fight and river clicks already exist in the repo. They are a
prior experiment. Do not keep the canoe as the main scene.

## Users

- **You (now)** - play in the Godot editor and build the tank ride.
- **You, then a friend (later)** - Windows zip if export stays simple. No
  accounts or access tiers.
- Not a live service, web game, or Steam store page in this pass.

## Features

Headline for `/feature`: **16a. Longer rail and turn** (next unchecked under
16). Items 1 and 2 are complete and superseded.

1. **Canoe native fight** (done, superseded) - grey-box river rail, natives, spears, 3 HP restart
2. **River clicks** (done, superseded) - hover-click props on the canoe; teaching object
12. **Tank rail ride** (done) - locked first-person camera on a tank that always moves; POLYGON WAR countryside into trenches into a ruined town; small HP readout
13. **Click-to-shoot** (done) - mouse-left reticle hitscan; click is always shoot
14. **Soldiers and slow shots** (done) - soldiers fire readable projectiles; shoot the shot or the shooter; three hits reload the whole ride
15. **Flavor shootables** (done) - barrels, crates, or signs react to a shot (mostly audio)
16. **Boss stretch** - longer rail with a turn into a bunker stretch; denser fight last; combat activates at checkpoints
  - 16a. **Longer rail and turn** - extend the path through a right-angle turn into a bunker approach; sparse dressing; camera still stops at path end
  - 16b. **Checkpoint combat waves** - activate small soldier waves at checkpoints so combat is incremental
  - 16c. **Boss stretch density** - final bunker checkpoints denser than earlier waves; same click, grenades, and 3 HP
17. **Windows download** - export a Windows zip if it stays simple; skip or defer if export becomes a project

Not in this MVP: cover / duck / still rooms, continues, silent secrets, puzzles,
extra branches, canoe-as-product.

## Data model

Nothing is persisted to disk. In-run state only.

### TankRun (features 12-16)

Reuse the canoe health rules on the tank scene. Do not add continues.

- `health` (int) - starts at 3; each projectile hit subtracts 1
- `is_alive` (bool) - false when health reaches 0
- `needs_restart` (bool) - true after a fatal fail; full tank-ride reload clears it

### Soldier (feature 14; checkpoint activate in 16b)

- `is_alive` (bool) - false after a successful hitscan on this shooter
- Fires slow, visible projectiles while alive and on-screen
- Load-bearing for 16b: start inactive until a checkpoint calls `activate()`

### SlowProjectile (feature 14)

- In-flight, readable war object (grenade). Destroyed if shot. Each player hit
  subtracts 1 health.

### FlavorShootable (feature 15)

- Shot with the same hitscan as combat. One-shot audio and visual reaction.
  No inventory pickup.

### CombatCheckpoint (feature 16b)

- One-shot trigger that activates a listed set of soldiers when the follow
  crosses it. No mass simultaneous activation of the whole ride.

### Canoe leftovers (do not extend)

`CanoeRun`, `Native`, `Spear`, and `Interactable` exist in canoe scenes. Treat
them as the old experiment. Do not add `spared_natives`, `has_idol`,
`current_section`, or `continues_remaining`.

## Tech stack

- **Godot 4** - engine (`config_version=5`; editor reported 4.7)
- **GDScript (typed)** - gameplay
- **3D rail** - locked first-person camera, always moving; path may yaw with a
  turn (no free look / steer)
- **Reticle + click-to-shoot** - one action, `shoot` (mouse left)
- **`assets/POLYGON WAR/`** - WWII pack library; search by name, do not dump
  the pack into context
- **Main scene:** `res://scenes/tank.tscn`
- **Editor Play (F5)** - how we verify; no test runner yet

## Monetization

Not in this project. Hobby / send-a-build.

## UI/UX

Somber WWII ground war. Slow tank. Methodical, not chaotic. Click to shoot.
Small HP readout. Hover may tint the reticle on a valid shot target. No cover
prompt, no inventory, no continue screen.

- `res://scenes/tank.tscn` - product ride
- `res://scenes/canoe.tscn` - leftover experiment

## Deployment

- **Now:** Godot editor. No export required for items 12-16.
- **Item 17:** Windows executable, zip, send a link, only if export stays
  simple. If it fights the project, stay editor-only.
- Repo: `DaveEstey/the-pat-project-v2`
- No Render/Vercel, no server, no env vars, no database.

## Open questions

- Exact turn radius and bunker dressing density are a 16a scene-tuning call.
- Item 17 may be skipped if Windows export becomes its own project.

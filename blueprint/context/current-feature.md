# Feature: Canoe native fight

**From build-plan:** feature 1
**Status:** not started

## Goal

A playable first-person canoe ride: the camera creeps down a river, natives
throw spears, click-to-shoot can destroy a spear or its thrower, and a spear
hit restarts the scene. This is the only encounter until it works.

## In scope

- Main 3D canoe scene set as the Godot main scene
- Locked first-person rail camera (moves forward, no look, no steer)
- On-screen reticle; mouse moves the reticle, not the camera
- Click (mouse left / `shoot`) fires a hitscan through the reticle
- At least two natives along the path who throw spears at the camera
- Shooting a spear destroys that spear; shooting a native stops that native throwing
- Spear-player hit sets `is_alive` false and reloads the canoe scene
- **All assets are grey box for this feature:** CSG / primitive meshes, untextured
  materials, flat grey (or one unlit color). River, banks, canoe, natives, spears,
  dummy, and any stand-in props. Do not import, retarget, or polish the WWII pack
  here even if files exist under `assets/`.
- Ride can reach the end of the rail without dying (camera stops; no win screen)

## Out of scope

- River flavor clicks, teaching objects, interact-vs-shoot cursor (feature 2)
- Cover, still rooms, tank, boss (features 3–5)
- `spared_natives`, `has_idol`, secret ending (feature 6)
- Continues / full-run game over (feature 7)
- Windows export (feature 8)
- Free look, driving the canoe, health bar, inventory HUD
- Real WWII (or any) art, textures, rigs, or audio from the asset pack

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Canoe scene and rail** - Add `res://scenes/canoe.tscn` as the main scene: grey-box river and banks (CSG/primitives only), a first-person camera that follows a slow Path3D down the water. *Done when:* Play (F5) opens a grey-box 3D river; the view creeps forward by itself; moving the mouse does not rotate the camera.

- [ ] **Step 2 - Reticle and hitscan** - Add a center-following reticle (mouse moves it in screen space) and a `shoot` action on mouse left that raycasts from the camera through the reticle. A debug dummy in the world reacts when hit. *Done when:* the reticle tracks the mouse, the camera still does not turn, and a click marks or removes the dummy.

- [ ] **Step 3 - Natives throw spears** - Place at least two grey-box native stand-ins (capsules/boxes) along the path. While on-screen they throw grey-box `Spear` projectiles toward the camera. Spears that miss despawn. No player death yet. *Done when:* during a Play run you see spears fly at the view from more than one thrower.

- [ ] **Step 4 - Shoot spears and throwers** - Hitscan destroys a spear on hit. Hitscan on a living native sets `is_alive` false and that native stops throwing. *Done when:* you can click a spear out of the air and click a native so that native throws no more spears.

- [ ] **Step 5 - Death restarts the ride** - Spear overlap with the player camera/body sets `CanoeRun.is_alive` false and `needs_restart` true, then reloads `canoe.tscn`. *Done when:* taking a spear hit returns you to the start of the river; surviving to the end of the rail stops the camera without reloading.

## Files / areas

- `project.godot` - main scene, `shoot` input
- `scenes/canoe.tscn` - river, path, camera, natives
- `scenes/native.tscn` (or equivalent) - thrower
- `scenes/spear.tscn` - projectile
- `scripts/canoe_run.gd` - `is_alive`, `needs_restart`, reload
- `scripts/rail_camera.gd` - path follow, no look
- `scripts/reticle_shoot.gd` - screen reticle + hitscan
- `scripts/native.gd`, `scripts/spear.gd`
- Grey-box primitives only. Do not wire `assets/` art in these steps.

## Data / contracts

Load-bearing for later flags: **do not write** `spared_natives` or `has_idol`.

### CanoeRun

- `is_alive` (bool) - false when a spear hits the player
- `needs_restart` (bool) - true after death; scene reload clears it

### Native

- `is_alive` (bool) - false after a successful hitscan on this thrower
- Spawns `Spear` instances while alive and on-screen

### Spear

- In-flight projectile. Queue-free if shot. Kills the player on body/camera hit.

Player shots are hitscan, not a second projectile type.

## Testing

No test command in `AGENTS.md`. No unit-test gate. Verify in the Godot editor
(Play / F5) with play-mode evidence (screenshot or short notes) per step.

- Step 1: camera moves, mouse does not yaw/pitch the view
- Step 2: reticle follows mouse; click hits the dummy
- Step 3: two throwers send spears at the camera
- Step 4: click spear = gone; click native = that native stops
- Step 5: spear hit = river starts over; reach the end alive = camera stops

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- Match `README.md` layout: `scenes/`, `scripts/`.
- Camera lock is the product: House of the Dead reticle, not FPS mouselook.
- Click is shoot only. Do not add interact, cover, HUD lives, or continue UI.
- Keep each step a small diff. Do not implement later build-plan items in this branch.
- Grey box until this feature is done. Do not swap in the asset pack mid-feature.

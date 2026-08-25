# Feature: Tank rail ride

**From build-plan:** feature 12
**Status:** complete

## Goal

Play starts on a first-person tank that always creeps forward through a short
POLYGON WAR rail: farm and hedges, then trenches, then a ruined town. A small
HP readout is on screen. There is no combat yet.

## Design reference

No mockup. Instance these library meshes from `res://assets/POLYGON WAR/FBX/`
(do not copy or edit the pack). Repeat a small set. Do not dress a dense
diorama.

- Tank: `SM_Veh_American_Tank_01.glb`
- Farm: `SM_Env_Hedge_01.glb`, `SM_Env_FarmRows_01.glb`, `SM_Bld_Barn_01.glb`,
  `SM_Env_Tree_Pine_01.glb`, `SM_Env_Road_Dirt_Straight_01.glb`
- Trench: `SM_Env_Trench_Straight_01.glb`, `SM_Env_Sandbag_Wall_01.glb`,
  `SM_Env_Dirt_Mound_01.glb`
- Town: `SM_Bld_TownHouse_01.glb`, `SM_Bld_Bunker_01.glb`

If a listed file is missing, search that folder by the same prefix and pick one
stand-in. Stop after the stand-in. Do not list the pack.

## In scope

- New main scene `res://scenes/tank.tscn` set in `project.godot`
- Locked first-person rail camera: always moving, no look, no steer, no duck
- Player rides `SM_Veh_American_Tank_01` (camera on the hull, not a free turret)
- One Path3D. Three readable stretches in order: farm, trench, town
- Small `HP 3/3` label (same rules as the old canoe HUD; no damage yet)
- Camera stops at the end of the path. No win screen
- Keep canoe scenes in the repo. Do not delete them

## Out of scope

- Click-to-shoot, reticle, hitscan (feature 13)
- Soldiers, projectiles, taking hits, scene reload on death (feature 14)
- Flavor shootables (feature 15)
- Boss stretch density (feature 16)
- Windows export (feature 17)
- Cover, duck, still rooms, continues, secrets
- Editing or duplicating files inside `assets/POLYGON WAR/`
- Inventory, menus, mouselook

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Tank scene, rail, and HP** - Add `res://scenes/tank.tscn` with
  a Path3D, reuse `scripts/rail_camera.gd` (or a thin copy if the canoe comment
  is wrong), `scripts/tank_run.gd` (`class_name TankRun`) with `health`,
  `is_alive`, `needs_restart`, and `%HealthLabel` showing `HP 3/3`. Point
  `project.godot` `run/main_scene` at the tank scene. Grey ground plane is fine.
  *Done when:* Play (F5) opens the tank scene, not the canoe; the view creeps
  forward by itself; the mouse does not rotate the camera; HP 3/3 is visible.

- [x] **Step 2 - Player tank mesh** - Instance `SM_Veh_American_Tank_01.glb` on
  the PathFollow with the camera. Fix instance scale so it reads as a tank
  under a first-person view. Do not edit the pack file. *Done when:* you ride
  a pack tank mesh down the rail; camera stays locked; canoe is not the main
  scene.

- [x] **Step 3 - Farm stretch** - First third of the path: dirt road, hedges,
  farm rows, one barn, a few pines, from the named meshes. Sparse placement
  along both sides. *Done when:* the first part of a Play run reads as
  countryside, not a grey plane.

- [x] **Step 4 - Trench stretch** - Middle third: trench, sandbags, dirt
  mounds from the named meshes. *Done when:* after the farm you pass a
  readable trench line while still moving.

- [x] **Step 5 - Town stretch and stop** - Last third: at least one townhouse
  and one bunker. Camera still stops at path end. Somber DirectionalLight /
  Environment if the scene is still default-bright. *Done when:* the ride
  ends in a ruined-town read and the camera stops; no combat; HP still 3/3.

## Files / areas

- `project.godot` - main scene `res://scenes/tank.tscn`
- `scenes/tank.tscn` - rail, tank, three stretches, HUD
- `scripts/tank_run.gd` - `TankRun` health fields and label
- `scripts/rail_camera.gd` - reuse for the tank follow
- `blueprint/context/coding-standards.md` - main scene path after this lands
- Instance pack glbs only. Do not modify `assets/POLYGON WAR/`

## Data / contracts

Nothing persisted. Do not write `spared_natives`, `has_idol`,
`current_section`, or `continues_remaining`.

### TankRun (load-bearing for 14-16)

- `health` (int) - starts at 3
- `is_alive` (bool) - stays true in this feature
- `needs_restart` (bool) - stays false in this feature
- `%HealthLabel` - `HP {health}/{max_health}`

`take_hit()` / `die()` may exist as in `CanoeRun` so feature 14 can call them,
but nothing deals damage in this feature.

## Testing

No test command in `AGENTS.md`. No unit-test gate. Verify in the Godot editor
(Play / F5) with play-mode evidence per step.

- Step 1: main scene is tank; camera moves; no mouselook; HP 3/3
- Step 2: pack tank is the vehicle
- Step 3: farm/hedge read
- Step 4: trench read
- Step 5: town/bunker read; camera stops at the end

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- New `.tscn` files need `uid=` on `[gd_scene]` and every `[ext_resource]`.
- POLYGON WAR is a library. Search by name. Do not enumerate the pack.
- Do not copy pack files into `scenes/`. Instance the `.glb` paths.
- Synty scale is often wrong on first import. Scale the instance, not the
  source file, until the tank sits under the camera.
- Reuse rail follow. Do not add shoot, reticle, soldiers, or duck.
- Leave `scenes/canoe.tscn` and canoe scripts in the repo.
- Sparse kitbash. A handful of instances per stretch is enough.
- No em dashes in files you write.

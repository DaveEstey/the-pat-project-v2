# Feature: Click-to-shoot

**From build-plan:** feature 13
**Status:** complete

## Goal

On the tank ride, mouse left is always shoot. A screen reticle follows the
mouse (the camera stays locked). A click fires a hitscan through the reticle.
A practice dummy along the rail proves the shot. There are no soldiers yet.

## Design reference

No mockup. Match the canoe HUD reticle: a `%Reticle` Control with two
`ColorRect` bars (`BarH` / `BarV`), idle color `Color(0.12, 0.12, 0.12, 1)`.
Do not invent a new crosshair style.

## In scope

- Reticle on `res://scenes/tank.tscn` HUD; mouse moves the reticle, not the camera
- Existing `shoot` action (mouse left in `project.godot`). No second bind
- Hitscan from `%Camera3D` through the mouse into the 3D world
- One practice dummy beside the rail that reacts to a hit (hide and disable
  collision). Grey-box primitive is enough
- `TankRun.is_alive` gates shooting so feature 14 can reuse it
- Hover tint on a valid shot target (same idle/hover colors as the canoe)

## Out of scope

- Soldiers, slow projectiles, taking damage, scene reload (feature 14)
- Flavor pack barrels/crates/signs and shot audio (feature 15)
- Boss density (feature 16)
- Windows export (feature 17)
- Interact-vs-shoot split, inventory, mouselook, duck
- Extending `CanoeRun`, `Native`, `Spear`, or `Interactable`
- Attaching `scripts/reticle_shoot.gd` to the tank (it is coupled to canoe
  groups and `CanoeRun`)
- Editing or duplicating files inside `assets/POLYGON WAR/`
- Changing the rail, stretches, or tank mesh from feature 12

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Tank reticle** - Add `%Reticle` under the tank HUD (same two
  ColorRect bars as the canoe). New `scripts/tank_shoot.gd` on a `Shooter`
  node: mouse-visible, reticle follows the cursor in `_process`. Do not raycast
  yet. *Done when:* Play (F5) shows a reticle that tracks the mouse; the camera
  still does not turn; HP still reads 3/3.

- [x] **Step 2 - Hitscan and practice dummy** - On `shoot`, raycast from the
  camera through the mouse (`collide_with_areas`, skip the player physics
  layer). Place one grey-box dummy (`%Dummy`, group `shot_target`) beside the
  rail in view during the farm stretch, with its own StaticBody collider on
  world layer 1. Hitting it calls `take_shot()` (hide + disable collision).
  Misses and a second click after it is gone do nothing. If the tank hull
  imported collision, exclude the hull from the ray so the dummy is reachable.
  Gate on `TankRun.is_alive`. *Done when:* a click on the dummy makes it
  vanish; a click on empty sky does not error; the ride still creeps forward.

- [x] **Step 3 - Hover tint** - While the ray hits a `shot_target`, tint the
  reticle to the canoe hover color `Color(0.82, 0.62, 0.2, 1)`. Idle color
  otherwise. *Done when:* the reticle warms over the dummy before you shoot and
  returns after the dummy is gone.

## Files / areas

- `scenes/tank.tscn` - HUD reticle, Shooter node, farm-stretch dummy
- `scripts/tank_shoot.gd` - reticle follow, hitscan, dummy/`shot_target` dispatch
- `project.godot` - reuse `shoot`; do not rename physics layers unless a new
  layer is required (prefer world layer 1 for the dummy)
- Leave `scripts/reticle_shoot.gd` and canoe scenes unchanged
- Do not modify `assets/POLYGON WAR/`

## Data / contracts

Nothing persisted. Do not write `spared_natives`, `has_idol`,
`current_section`, or `continues_remaining`.

### TankRun (already shipped)

- `is_alive` (bool) - shots no-op when false
- `health` / `needs_restart` - unused by this feature

### Shot target (load-bearing for 14-15)

- Group: `shot_target`
- Method: `take_shot() -> void`
- Hitscan walks from the collider up the tree and calls `take_shot()` on the
  first node in `shot_target`
- Feature 14 soldiers and slow projectiles join this group (or a later group
  the same shooter also checks). Do not add those nodes here
- Feature 15 flavor props use the same click and the same ray, not a second
  input

### Physics

- Dummy: collision layer 1 (`world`)
- Ray mask includes world (1). Do not hit the player layer (layer 3, bit value
  4) if a hurtbox appears later
- Tank hull must not eat the ray

## Testing

No test command in `AGENTS.md`. No unit-test gate. Verify in the Godot editor
(Play / F5).

- Step 1: reticle tracks mouse; no mouselook; HP 3/3
- Step 2: dummy vanishes on click; miss is safe; camera still locked
- Step 3: hover tint on dummy, idle after it is gone

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- New `.tscn` files need `uid=` on `[gd_scene]` and every `[ext_resource]`.
  This feature should not need a new scene file if the dummy lives in
  `tank.tscn`.
- Click is always shoot. Do not call `interact()`.
- Do not extend canoe types. Copy the reticle + ray *pattern*, not the canoe
  script.
- Keep the dummy a primitive, not a pack flavor prop.
- Mouse filter on HUD controls: ignore so clicks reach the shooter
  (`mouse_filter = 2`).
- Input.mouse_mode stays visible.
- No em dashes in files you write.
- Overview still names canoe as the live main scene; that is stale. Product
  main scene is `res://scenes/tank.tscn`.

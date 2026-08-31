# Feature: Soldiers and slow shots

**From build-plan:** feature 14
**Status:** complete

## Goal

Along the tank rail, soldiers fire slow, readable grenades at you. You can
shoot the grenade or the shooter with the same click. A hit costs 1 HP. Three
hits reload the whole tank ride. The practice dummy from feature 13 still works.

## Design reference

No mockup. Instance these library meshes (do not copy or edit the pack):

- Soldier: `res://assets/POLYGON WAR/Characters/Character_German_Soldier_01.glb`
- Projectile: `res://assets/POLYGON WAR/FBX/SM_Wep_German_Grenade_01.glb`

If a named file is missing, search that folder by the same prefix and pick one
stand-in. Stop after the stand-in. Do not list the pack. If instance scale
makes the soldier or grenade unreadable, grey-box primitives are allowed as a
fallback for that mesh only; keep the contracts the same.

## In scope

- At least two soldiers beside the rail (prefer the trench stretch), each
  firing while alive and on-screen
- Slow, visible grenade projectiles that track toward the camera (not tiny
  bullets)
- Shoot a soldier: that soldier stops firing (`is_alive` false)
- Shoot a grenade: that grenade is destroyed
- Player hurtbox on the tank follow; a grenade hit calls `TankRun.take_hit()`
  deferred (never reload inside a physics callback)
- Three hits: `die()` reloads `res://scenes/tank.tscn` via existing
  `TankRun` logic
- Same `shoot` action and reticle; soldiers and grenades join `shot_target`
  with `take_shot()`
- Hover tint already covers `shot_target`; keep that working for soldiers and
  grenades
- Keep the feature 13 practice dummy

## Out of scope

- Flavor barrels/crates/signs (feature 15)
- Boss density / denser town fight (feature 16)
- Windows export (feature 17)
- Continues, section restart, silent secrets
- Extending `CanoeRun`, `NativeThrower`, `Spear`, or `Interactable`
- New input binds, mouselook, duck, free aim turret
- Editing or duplicating files inside `assets/POLYGON WAR/`
- Changing farm/trench/town dressing except placing soldiers

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Player hurtbox** - Add a `Hurtbox` Area3D under
  `Rail/Follow` (group `player`, collision_layer = 4 / player). Size it so a
  grenade reaching the camera can hit it. Do not change shoot yet. *Done when:*
  Play (F5) still rides and shoots the dummy; a `%Hurtbox` exists on the
  follow; HP still 3/3.

- [x] **Step 2 - Slow grenade projectile** - New `scenes/slow_projectile.tscn`
  + `scripts/slow_projectile.gd` (`class_name SlowProjectile`). Area3D on
  spears layer (2), mask player (4), group `shot_target`, `take_shot()` frees
  it. Mesh is the German grenade (or a grey-box stand-in). `setup(from, toward)`
  aims at the camera, moves slowly, despawns on miss/lifetime. Overlap or
  camera proximity calls `TankRun.take_hit()` deferred once, then frees.
  Temporarily spawn one from a Marker or a one-shot test so you can take a hit.
  *Done when:* a grenade flies at the view, one contact drops HP to 2/3, and
  clicking the grenade destroys it (extend `tank_shoot` ray mask to include
  spears layer 2).

- [x] **Step 3 - Soldiers fire** - New `scenes/soldier.tscn` +
  `scripts/soldier.gd` (`class_name Soldier`). Instance the German soldier
  mesh (scale the instance, not the pack file). While `is_alive` and on-screen
  (`VisibleOnScreenNotifier3D`), spawn `SlowProjectile` toward the camera on
  an interval. Place at least two soldiers along the trench stretch beside the
  rail. Collider on interact layer (8), group `shot_target`. *Done when:*
  during a Play run you see two soldiers and readable grenades coming at you
  without needing the temporary Step 2 spawn.

- [x] **Step 4 - Shoot soldiers and survive or die** - Soldier `take_shot()` /
  `down()` sets `is_alive` false, stops firing, and disables its collider
  (darken or hide is fine). Remove any temporary Step 2 auto-spawn. Confirm:
  shoot a grenade out of the air; shoot a soldier so that one stops; one hit
  does not reload; three hits reload the tank scene with no physics-callback
  error; surviving to the path end still stops the camera. *Done when:* all of
  those behaviors work in one Play session.

## Files / areas

- `scenes/tank.tscn` - hurtbox, soldier instances, keep dummy
- `scenes/soldier.tscn`, `scripts/soldier.gd`
- `scenes/slow_projectile.tscn`, `scripts/slow_projectile.gd`
- `scripts/tank_shoot.gd` - ray mask includes spears (2) and interact (8);
  keep `shot_target` / `take_shot` dispatch
- `scripts/tank_run.gd` - already has `take_hit` / `die`; only touch if a small
  fix is required
- Instance pack glbs only. Do not modify `assets/POLYGON WAR/`
- Leave canoe scenes and canoe scripts unchanged

## Data / contracts

Nothing persisted. Do not write `spared_natives`, `has_idol`,
`current_section`, or `continues_remaining`.

### TankRun (already shipped)

- `health` (int) - starts at 3; each projectile hit subtracts 1
- `is_alive` (bool) - false at 0 health
- `needs_restart` (bool) - true after `die()`
- `take_hit()` / `die()` - deferred reload of the current scene

### Soldier (load-bearing)

- `class_name Soldier`
- `is_alive` (bool) - false after a successful hitscan
- Group: `shot_target`
- Method: `take_shot() -> void` (same as `down()` behavior)
- Fires only while alive and on-screen

### SlowProjectile (load-bearing)

- `class_name SlowProjectile`
- Group: `shot_target`
- Method: `take_shot() -> void` - destroys this projectile
- Collision layer 2 (`spears`); mask includes player (4)
- One player hit per instance; then free
- Readable size and slow speed (roughly canoe-spear pace or slower)

### Shot target (from feature 13)

- Hitscan finds `shot_target` and calls `take_shot()`
- Ray mask: interact (8) | spears (2)
- Dummy remains a `shot_target`

### Physics

| Role | Layer | Notes |
|---|---|---|
| World | 1 | scenery |
| Projectiles | 2 | spears layer name; tank combat uses it |
| Player hurtbox | 3 / bit 4 | group `player` |
| Shootable soldiers / dummy | 4 / bit 8 | interact |

## Testing

No test command in `AGENTS.md`. No unit-test gate. Verify in the Godot editor
(Play / F5).

- Step 1: hurtbox present; dummy still shootable; HP 3/3
- Step 2: grenade visible; click destroys it; contact drops HP once
- Step 3: two trench soldiers throw while on-screen
- Step 4: shoot shot / shoot shooter; 1 hit survives; 3 hits reload; end of
  rail still stops without reload

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- New `.tscn` files need `uid=` on `[gd_scene]` and every `[ext_resource]`.
- Copy the canoe *pattern* (on-screen throw, deferred hit, group hitscan). Do
  not extend canoe classes.
- Prefer `call_deferred("take_hit")` from the projectile, matching spear.
- Synty scale is often wrong. Scale the soldier and grenade instances until
  they read as a person and a throwable, not ants or walls.
- Sparse: two soldiers is enough. Do not densify for the boss (feature 16).
- Keep click always shoot. No `interact()`.
- Mouse filter on HUD stays ignore.
- No em dashes in files you write.
- Overview may still say canoe is the main scene; product main scene is
  `res://scenes/tank.tscn`.

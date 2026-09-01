# Feature: Checkpoint combat waves

**From build-plan:** feature 16b
**Status:** complete

## Goal

Combat starts in small waves when the tank crosses checkpoints, instead of every
soldier being live from the start. Trench (and a light town-approach wave) only
fire after their checkpoint. Same soldiers, grenades, click, and 3 HP. Boss
density stays 16c.

## Design reference

No mockup. Reuse `res://scenes/soldier.tscn`. Place thin `CombatCheckpoint`
triggers along the existing rail from 16a.

## In scope

- Soldiers start **inactive**: no throws, collider off (not shootable), still
  present in the scene (visible is fine so the stretch reads as occupied)
- `Soldier.activate()` arms one soldier once: restores collider, allows throws
- Dead soldiers (`down()`) stay down; `activate()` is a no-op if already armed
  or already downed
- New `CombatCheckpoint`: one-shot trigger that activates soldiers in a
  `wave_group` when the follow / player hurtbox crosses it
- Prefer an `Area3D` that detects the existing `Hurtbox` (player layer 4)
- Convert existing trench `Soldier1` / `Soldier2` to a first checkpoint wave
- Add at least one more wave of 1-2 soldiers on the town approach (pre-turn),
  on a second checkpoint farther along the path
- Waves do not all fire at once: later checkpoints do not arm earlier soldiers
  again
- Flavor props, dummy, HP reload, and path end still work

## Out of scope

- Boss / bunker density and faster throw intervals (16c)
- Windows export (17)
- Unique boss, rail pause, duck, continues
- Instantiating soldiers at runtime from a pool (pre-placed + activate is enough)
- Soldier placement polish in bunkers/buildings (deferred)
- Editing `assets/POLYGON WAR/`

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Soldier inactive + activate** - Update `scripts/soldier.gd`:
  start inactive (no throws, body collision_layer 0). Add `activate() -> void`
  that arms once and restores layer 8. Keep `take_shot()` / `down()` behavior
  for armed soldiers. *Done when:* a Play or debugger call shows an inactive
  soldier does not throw; after `activate()` it throws when on-screen; after
  `down()` it stays down.

- [x] **Step 2 - CombatCheckpoint type** - Add `scripts/combat_checkpoint.gd`
  (`class_name CombatCheckpoint`) and `scenes/combat_checkpoint.tscn`. On first
  detection of the player hurtbox (Area3D mask player layer 4), call
  `activate()` on each soldier in `wave_group` and disable itself. *Done when:*
  a checkpoint in the scene arms soldiers when the tank reaches it.

- [x] **Step 3 - Wire waves on the ride** - Trench pair on checkpoint 1 near
  trench entry. Place 1-2 town-approach soldiers on checkpoint 2 before the
  turn. No bunker boss cluster yet (16c). *Done when:* Play shows trench
  soldiers silent until CP1, then active; town-approach wave only after CP2;
  shooting and HP still work; path still turns and stops.

## Files / areas

- `scripts/soldier.gd`, `scenes/soldier.tscn`
- `scripts/combat_checkpoint.gd`, `scenes/combat_checkpoint.tscn`
- `scenes/tank.tscn` - checkpoints + town-approach soldier placements
- Do not modify `assets/POLYGON WAR/`

## Data / contracts

### Soldier (load-bearing update)

- Starts inactive until `activate()`
- `activate() -> void` - one-shot arm
- `_armed` separate from `is_alive` (dead vs waiting for checkpoint)
- `is_alive` / `down()` / `take_shot()` unchanged once armed

### CombatCheckpoint (load-bearing, new)

- One-shot
- `@export var wave_group: StringName` - activates all nodes in that group
- Triggers via player hurtbox overlap (layer 4)
- Does not despawn the ride or pause the rail

## Testing

No test command in `AGENTS.md`. Verified in the Godot editor (Play / F5).

- Step 1: inactive then activate then down
- Step 2: crossing checkpoint arms wave group once
- Step 3: two sequential waves on a full Play run

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- Hurtbox is `Rail/Follow/Hurtbox`, group `player`, layer 4.
- Wave groups: `wave_trench`, `wave_town`.
- Checkpoint z must be upstream (higher Z) of its soldiers on this rail.
- Placement polish is deferred; do not block 16c on repositioning.

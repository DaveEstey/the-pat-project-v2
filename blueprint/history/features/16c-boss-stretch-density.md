# Feature: Boss stretch density

**From build-plan:** feature 16c
**Status:** complete

## Goal

After the rail turn, the bunker approach feels like the denser final fight:
more soldiers than trench or town, released in one or two bunker checkpoints,
still incremental via `CombatCheckpoint`. Same click, grenades, and 3 HP. No
unique boss entity.

## Design reference

No mockup. Reuse `soldier.tscn` and `combat_checkpoint.tscn` on the post-turn
stretch from 16a (path runs toward +X near z=-50, bunker dressing already
present). Soldier positions can be rough; placement in bunkers/buildings is a
later polish pass.

## In scope

- At least **four** bunker soldiers on the post-turn stretch (vs two per
  earlier wave), inactive until checkpoints fire
- At least **two** bunker checkpoints (`wave_bunker_1`, `wave_bunker_2`) so
  pressure builds in sequence, not one mega-wave
- Each bunker checkpoint arms 2 soldiers (groups, same pattern as 16b)
- Optional per-instance `throw_interval` override on bunker soldiers only
  (e.g. ~2.0s vs default 2.4s); leave trench/town defaults unchanged
- Checkpoints placed **upstream** on the path before their soldiers (after the
  turn, lower path progress / earlier +X than the soldiers they arm)
- Same contracts: `Soldier.activate()`, `CombatCheckpoint.wave_group`, 3 HP
  reload, flavor props, dummy, path end stop
- Completes parent **16. Boss stretch** when this sub-feature ships

## Out of scope

- Windows export (17)
- Unique boss HP bar, phases, or special weapon
- Rail pause, duck, continues
- Repositioning trench/town soldiers or flavor props (deferred polish)
- Hiding soldiers inside bunker mesh collision (visual polish later)
- New projectile type or Soldier subclass
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

- [x] **Step 1 - Bunker soldier cluster** - Under `Soldiers/BunkerApproach`,
  instance four `soldier.tscn` nodes (inactive by default). Assign
  `wave_bunker_1` to two and `wave_bunker_2` to two. Place on the post-turn
  +X stretch near existing bunker dressing (rough positions OK). Do not change
  trench/town soldiers or checkpoints. *Done when:* Play (F5) shows four extra
  soldiers visible along the bunker approach but none throw until a checkpoint
  (they stay inactive through trench and town waves).

- [x] **Step 2 - Bunker checkpoints** - Add `CP_Bunker1` and `CP_Bunker2` under
  `Checkpoints` on the post-turn path. `CP_Bunker1` uses `wave_bunker_1`;
  `CP_Bunker2` uses `wave_bunker_2`. Place each gate upstream of its soldiers
  along travel (+X after the turn). *Done when:* Play shows bunker wave 1
  after the turn, then wave 2 farther along; earlier waves unchanged.

- [x] **Step 3 - Density tune and coexistence** - Optionally shorten
  `throw_interval` on bunker soldiers only if the fight still feels too sparse.
  Confirm: shoot soldiers/grenades; 3 HP reload; flavor/dummy work; ride still
  stops at path end. If four armed soldiers feel unfair, stagger CP2 farther or
  slow bunker intervals rather than adding more. *Done when:* one Play run
  feels denser than town/trench but readable on 3 HP.

## Files / areas

- `scenes/tank.tscn` - bunker soldiers, `CP_Bunker1`, `CP_Bunker2`
- Possibly `scripts/soldier.gd` only if a tiny export default tweak is needed
  (prefer instance overrides in `tank.tscn`)
- Reuse `scripts/combat_checkpoint.gd`, `scenes/combat_checkpoint.tscn`
- Do not modify `assets/POLYGON WAR/`

## Data / contracts

Reuse 16b contracts unchanged:

### Soldier

- Inactive until `activate()`; `_armed` vs `is_alive`

### CombatCheckpoint

- `wave_group: StringName` one-shot arms all nodes in group

### New groups (load-bearing for this sub-feature)

- `wave_bunker_1` - first bunker pair
- `wave_bunker_2` - second bunker pair

Do not reuse `wave_trench` or `wave_town` for bunker soldiers.

## Testing

No test command in `AGENTS.md`. Verify in the Godot editor (Play / F5).

- Step 1: four inactive bunker soldiers visible, no early throws
- Step 2: two sequential bunker waves after the turn
- Step 3: denser but fair; full ride coexistence

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- Rail after turn: path progress increases toward +X (~0,-50 to ~80,-50).
  Checkpoints must fire **before** their soldiers along that direction.
- Groups on soldier instances: `groups=["wave_bunker_1"]` in `tank.tscn`.
- Keep incremental: two checkpoints, two pairs. Do not arm all four at once.
- Placement polish explicitly deferred; rough coords are fine for MVP.
- No em dashes in files you write.
- Product main scene is `res://scenes/tank.tscn`.

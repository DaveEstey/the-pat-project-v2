# Feature: Longer rail and turn

**From build-plan:** feature 16a
**Status:** complete

## Goal

Extend the tank rail past the townhouse stretch through a right-angle turn into
a bunker approach so the denser boss fight has geography after the first part.
Sparse dressing only. Camera still stops at the path end. No new combat rules
in this sub-feature.

## Design reference

No mockup. Reuse existing POLYGON WAR instances already in `scenes/tank.tscn`
(road, sandbags, mounds, bunker, townhouse). Move the bunker onto the post-turn
stretch. Search the pack by name only if a stand-in is required. Do not list the
pack.

## In scope

- Extend `CurveRail` with multiple points: farm to trench to town approach,
  right-angle turn, bunker approach, stop
- PathFollow yaws with the path on the turn (`ROTATION_Y`) so the view turns
  with the tank; still no free look or steer
- Enlarge or add ground so the post-turn stretch is not floating on void
- Sparse dressing along the turn and bunker approach (reuse road / bags /
  mound / pine as needed)
- Relocate the bunker mesh to the post-turn section; keep townhouse on the
  pre-turn approach
- Remove the premature `Soldiers/BossStretch` town soldiers from the aborted
  density pass (trench `Soldier1` / `Soldier2` stay)
- Flavor props and farm dummy stay; adjust positions only if they sit on the
  void after the ground change
- Path end still stops the camera (`progress_ratio` clamp)

## Out of scope

- Checkpoint activation system (16b)
- Boss density / denser bunker soldiers (16c)
- Windows export (17)
- Unique boss, rail pause, duck, continues
- New projectile types
- Editing or duplicating files inside `assets/POLYGON WAR/`

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Extend curve and yaw** - Replace the 2-point straight
  `CurveRail` with a multi-point path that runs south through town, turns
  right-angle toward +X into a bunker approach, and ends farther out. Set
  `PathFollow3D` rotation to yaw with the path. Remove `Soldiers/BossStretch`
  and its four town soldiers. *Done when:* Play (F5) rides a longer path that
  visibly turns, then continues; no BossStretch soldiers; trench pair still
  present; camera stops at the end.

- [x] **Step 2 - Ground and bunker approach dressing** - Enlarge or add ground
  under the new stretch. Move the bunker to the post-turn side of the path.
  Add a handful of sparse props (road / sandbags / mound) along the turn and
  bunker approach. Keep townhouse on the pre-turn approach. *Done when:* Play
  shows continuous ground through the turn, a readable bunker on the post-turn
  stretch, and no obvious floating void under the camera path.

## Files / areas

- `scenes/tank.tscn` - curve, ground, Town/Bunker placement, dressing, remove
  BossStretch
- `scripts/rail_camera.gd` - yaw with path (`ROTATION_Y`)
- Do not modify `assets/POLYGON WAR/`

## Data / contracts

Nothing new persisted. Rail geometry only. Checkpoint and Soldier `activate()`
wait for 16b.

## Testing

No test command in `AGENTS.md`. Verify in the Godot editor (Play / F5).

- Step 1: longer path, visible turn, stop at end, no BossStretch soldiers
- Step 2: ground and bunker read on the post-turn stretch

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- Curve3D point data in `.tscn` is in/out/position triples per point.
- Prefer `ROTATION_Y` so pitch stays on the Camera3D local transform.
- Sparse kitbash. A handful of instances on the new stretch is enough.
- No em dashes in files you write.
- Product main scene is `res://scenes/tank.tscn`.

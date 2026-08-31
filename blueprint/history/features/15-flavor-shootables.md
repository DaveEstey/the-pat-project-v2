# Feature: Flavor shootables

**From build-plan:** feature 15
**Status:** complete

## Goal

Along the tank rail, a few pack props (barrel, crate, sign) react when you
shoot them. Same click as combat. Mostly audio, plus a small one-time visual
tell. No inventory and no second input.

## Design reference

No mockup. Instance these library meshes from `res://assets/POLYGON WAR/FBX/`
(do not copy or edit the pack):

- Barrel: `SM_Prop_Barrel_01.glb`
- Crate: `SM_Prop_Crate_01.glb`
- Sign: `SM_Env_Sign_01.glb`

If a listed file is missing, search that folder by the same prefix and pick one
stand-in. Stop after the stand-in. Do not list the pack.

## In scope

- New `FlavorShootable` type: group `shot_target`, method `take_shot()`
- Same `shoot` hitscan and hover tint already used by dummy / soldiers /
  grenades (no `interact()`, no second bind)
- At least three props along the rail (one barrel, one crate, one sign),
  placed off the soldier line so they do not steal combat clicks
- First shot: play a short sound and a small one-time visual reaction (tilt,
  hide, or color change)
- Later shots on the same prop: no-op (no sound, no further reaction), like a
  door already shot open
- Reuse `res://assets/sfx/click.wav` when present; otherwise a tiny generated
  beep like the canoe `Interactable` fallback
- Combat still works: soldiers, grenades, dummy, HP

## Out of scope

- Boss stretch density (feature 16)
- Windows export (feature 17)
- Puzzle / route-changing hatches
- Inventory, pickups, silent secrets
- Extending canoe `Interactable` / `reticle_shoot.gd`
- Physics debris, particle explosions, new SFX pack imports
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

- [x] **Step 1 - FlavorShootable type** - Add `scenes/flavor_shootable.tscn` and
  `scripts/flavor_shootable.gd` (`class_name FlavorShootable`). Root in group
  `shot_target`. Collider on interact layer (8). `take_shot()` plays audio via
  an `AudioStreamPlayer` and applies a one-time small visual reaction. Scale the
  pack mesh instance like other tank props (often 100). Do not place it in the
  main ride yet. *Done when:* the scene opens alone or as a temp instance and a
  click (or calling `take_shot()` from the debugger) plays sound and shows a
  reaction; a second call does not error.

- [x] **Step 2 - Place three along the rail** - Instance one barrel, one crate,
  and one sign in `scenes/tank.tscn` (farm, trench, and town stretches, or
  sparse along the sides). Keep them clear of soldier and dummy lines.
  *Done when:* Play (F5) lets you shoot each prop for audio + reaction; hover
  tints the reticle on them; soldiers and grenades still work.

- [x] **Step 3 - Repeat clicks and combat check** - Confirm repeat clicks on a
  flavor prop are silent no-ops after the first activate. Confirm dummy,
  soldiers, grenades, and HP still behave as in feature 14. *Done when:* one
  Play run proves flavor props and combat coexist.

## Files / areas

- `scenes/flavor_shootable.tscn`, `scripts/flavor_shootable.gd`
- `scenes/tank.tscn` - three sparse instances
- Possibly `assets/sfx/click.wav` (reuse only; do not invent a new pack)
- Leave canoe `Interactable` and `reticle_shoot.gd` unchanged
- Do not modify `assets/POLYGON WAR/`

## Data / contracts

Nothing persisted.

### FlavorShootable (load-bearing)

- `class_name FlavorShootable`
- Group: `shot_target`
- Method: `take_shot() -> void`
- Collision layer 8 (`interact`)
- Optional `@export var click_sound: AudioStream`
- Optional `@export var react_on_click: bool` (default true for one-time visual)

Uses the existing tank hitscan. Do not add a second ray or input action.

## Testing

No test command in `AGENTS.md`. No unit-test gate. Verify in the Godot editor
(Play / F5).

- Step 1: sound + reaction on `take_shot`
- Step 2: three props visible and shootable on the ride
- Step 3: repeat click safe; combat loop intact

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- New `.tscn` files need `uid=` on `[gd_scene]` and every `[ext_resource]`.
- Click is always shoot. Call `take_shot()`, never `interact()`.
- Do not extend canoe types. Copy the audio *pattern* from `Interactable` if
  useful (beep fallback).
- Sparse: three props total is enough.
- Synty scale: instance scale, not pack edits. Match nearby tank props.
- No em dashes in files you write.
- Overview may still say canoe is the main scene; product main scene is
  `res://scenes/tank.tscn`.

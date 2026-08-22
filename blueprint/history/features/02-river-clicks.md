# Feature: River clicks

**From build-plan:** feature 2
**Status:** complete

## Goal

On the canoe ride, the same left click both shoots combat and interacts with
the world. Hovering a river prop changes the reticle. Clicking wildlife or
props plays a short sound. One teaching object makes that clickable world
obvious. This is flavor and teaching, not inventory or routing.

## In scope

- Same `shoot` action (mouse left). No second bind.
- Hitscan that already finds spears and natives also finds interactables.
- If the first hit is an interactable, call `interact()` and do not shoot.
- If the first hit is a spear, native, or the dummy, keep today's shoot
  behavior.
- Hover over an interactable tints the reticle. Hover over combat or empty
  air does not.
- At least two grey-box flavor props along the rail (wildlife or bank clutter).
  Click plays a short placeholder sound. Repeat clicks replay the sound.
- One teaching object: visually distinct from flavor props, a small on-screen
  or in-world hint, click plays audio and a visible reaction (tilt, hide, or
  color change).
- Props sit off the native/spear line so they do not eat combat clicks.
- Clicks do nothing after `CanoeRun.is_alive` is false.
- Grey box meshes. Placeholder audio committed in-repo (tiny `.wav` under
  `assets/sfx/`, or an equivalent `AudioStreamWAV` the editor can play). Do
  not import the WWII pack.

## Out of scope

- Cover, tank, boss (features 3-5)
- `spared_natives`, `has_idol`, idol collect, secret ending (feature 6)
- Continues / game over (feature 7)
- Windows export (feature 8)
- Hatch/latch puzzles that change a route (feature 9)
- Inventory, bags, pickup UI
- New input actions, free look, driving the canoe
- Real wildlife art or pack audio
- Removing the feature-1 dummy (leave it; it stays a shoot target)

## Build loop

Build one step at a time, never the whole feature at once.

1. Plan mode lays out the step before any code.
2. The AI implements just that step.
3. It shows the diff (not full files); you read it and understand it.
4. You approve, then choose whether to commit a checkpoint or roll straight on.
   Checkpoints are optional; `/complete` makes the real feature-level commit at the end.

Never accept a step you haven't read. If a diff is too big to review, the step was too big, so split it.

## Build steps

- [x] **Step 1 - Interact layer and hover tint** - Add physics layer 8 for
  interactables. Add `scripts/interactable.gd` (`class_name Interactable`) and
  one grey-box prop on a bank in `canoe.tscn`, group `interactable`, layer 8.
  Extend the reticle ray to include layer 8 for hover only. Tint the reticle
  when the hover hit is an interactable. Combat click path stays unchanged
  (still mask `1|2`). *Done when:* Play (F5): hovering the new bank box tints
  the reticle; hovering a native or empty air does not; click still downs a
  native and still destroys a spear.

- [x] **Step 2 - Same click, interact or shoot** - On `shoot`, raycast mask
  `1|2|8`. First hit wins: interactable calls `interact()` and does not shoot;
  spear/native/dummy keep current shoot. `interact()` on the Step 1 box plays
  one placeholder sound. Ignore the click if `CanoeRun.is_alive` is false.
  *Done when:* click the box plays a sound and does not down a native behind
  it; click a native still downs; click a spear still destroys it; three hits
  still restart.

- [x] **Step 3 - Flavor props along the river** - Place at least two more
  clickable grey-box wildlife/prop stand-ins along the rail, visible during
  the ride, off the combat line. Each plays a different short placeholder
  sound. Repeat clicks replay. *Done when:* in one Play run you can click two
  different river props (not the teaching object) and hear two different
  sounds; natives and spears still shootable.

- [x] **Step 4 - Teaching object** - Add one distinct clickable (different
  shape or color from flavor props) with a small hint (Label or Label3D) that
  the world is clickable, plus a visible click reaction and audio. Hint is
  teaching only, not a menu. *Done when:* you can spot the teaching object
  without reading this spec; clicking it plays audio and shows a visible
  change; flavor clicks and combat still work.

## Files / areas

- `project.godot` - name physics layer 8 if the project lists layer names
- `scripts/interactable.gd` - `interact()`, audio, optional one-shot reaction
- `scripts/reticle_shoot.gd` - hover tint; click routes interact vs shoot
- `scenes/canoe.tscn` - flavor props, teaching object, hint
- `scenes/river_click.tscn` (or instances of Interactable in the canoe scene)
- `assets/sfx/` - tiny placeholder wavs (bird, rustle, teach), not pack audio
- Do not change spear damage, health, or rail motion except to read `is_alive`

## Data / contracts

Nothing persisted. Do not write `spared_natives` or `has_idol`.

### Interactable (new, load-bearing)

Later idol collect should reuse this click path. Feature 2 must not set
`has_idol`.

- Group: `interactable`
- Collision layer: 8
- `interact() -> void` - play audio; teaching object also runs its visible
  reaction
- Optional exported `AudioStream` for the click sound

### Click routing (load-bearing)

- One action: `shoot` (mouse left)
- One ray from the camera through the mouse
- Mask: `1 | 2 | 8` on click (world/natives, spears, interactables)
- First collider wins
- Interactables never take spear damage and never call `Native.down()`

### CanoeRun (unchanged)

- `health`, `is_alive`, `needs_restart` stay as shipped
- Dead: no shoot, no interact

## Testing

No test command in `AGENTS.md`. No unit-test gate. Verify in the Godot editor
(Play / F5) with play-mode evidence (screenshot or short notes) per step.

- Step 1: reticle tints on the bank box only; combat click unchanged
- Step 2: box click = sound, not a kill; native click = down; spear click =
  gone; death still restarts after three hits
- Step 3: two flavor props, two different sounds, during the ride
- Step 4: teaching object is obvious; click = audio + visible reaction

## Notes for the AI

- Godot 4, typed GDScript, `res://` paths only. No C#.
- New `.tscn` files need `uid=` on `[gd_scene]` and every `[ext_resource]`.
- Match `README.md` layout: `scenes/`, `scripts/`, `assets/sfx/`.
- Keep the House of the Dead reticle. Do not add mouselook.
- Hover feedback is reticle tint, not a custom OS cursor file.
- Generate short placeholder wavs if none exist. Do not silence-fail interact.
- Place props on the banks, not between camera and natives.
- Keep each step a small diff. Do not start cover, idol, or continues.
- Grey box. Do not wire `assets/` WWII art in these steps.
- No em dashes in files you write.

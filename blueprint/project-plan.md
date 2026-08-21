# Project Plan

> User-owned plan. Edit this file directly whenever the product direction
> changes, then re-run `/overview`.

## 1. Problem - What problem are we solving?

The Pat Project is a 3D first-person on-rails shooter. The long-term slice is a
short, somber jungle run: canoe, two cover stands, a tank stretch, a boss, and
silent secrets. Dark and methodical, not chaotic.

**Right now the only problem we are solving is the first encounter.** Get a
playable canoe ride with a native spear fight that you can finish, fail, and
restart. Nothing else ships until that loop works.

## 2. Users - Who is this for?

- **Now:** you, playing in the Godot editor.
- **After the canoe works:** keep building the rest of the short game, then a
  Windows download for a friend.
- Not a live service, not a web game, not Steam for this pass.

## 3. Features - What does the first encounter need?

### Now (build this only)

- First-person locked camera on a canoe. The view creeps forward; you do not
  look around freely.
- Reticle. Click to shoot.
- Natives throw spears. Shoot the **spear or the thrower**, or you die.
- On death, restart the canoe ride. No continue economy yet.
- The camera keeps moving. It does not wait for a wave clear.
- Enough jungle/WWII scenery to read the scene. Use the asset pack in `assets/`
  when it is present; placeholders are fine until then.

### Later (the small MVP, after the canoe is functional)

Keep this as the target shape. Do not spec or build it until encounter 1 works.

- River flavor clicks (wildlife/props, mostly audio, one teaching object)
- Two still Time Crisis cover fights after the boat
- Tank rail (moving, no cover)
- Boss stand (weak points, more health)
- Silent flags: spare natives (help at boss), idol (secret ending treasure)
- Limited continues, then full-run game over
- Windows zip / download link

## 4. Data - What are we storing?

**Now:** nothing persistent. In-run only, if needed (alive / dead / restart).

**Later:** current section, continues, `spared_natives`, `has_idol`. No accounts,
no server, no visible inventory.

## 5. Tech - What stack are we using?

- Godot 4 (`config_version=5`; editor reported 4.7)
- GDScript, typed
- 3D, first-person rail camera, reticle shots
- WWII assets in `assets/` when uploaded
- Verify by playing in the editor (Play / F5)

## 6. Monetize - How will this make money?

None.

## 7. UI/UX - How should this look and feel?

**Now:** dark, slow river. Gun reticle. Click to fire. No cover, no inventory
HUD, no menu beyond restarting the ride.

**Later:** interact cursor on wildlife, hold-to-duck in still stands, small
continue display, secret ending beat if the idol was collected.

## 8. Deployment - Where and how will this ship?

**Now:** run from the Godot editor. No export work until the canoe fight is
playable.

**Later:** Windows executable, zip, send a link. No Render/Vercel, no server.

## Explicit non-goals (until the canoe works)

- Cover, tank, boss, second rooms
- River flavor clicks and teaching objects
- Spare-natives flag and idol
- Continues / game over across a full run
- Inventory UI, extra branches, hatch puzzles
- Driving the boat, camera look, Steam, web, level select
- Windows export

## Assumptions

- Same click will later mean enemy = shot and prop = interact. For this
  encounter, click is only shoot.
- Canoe death is a full scene restart, not a continue screen.

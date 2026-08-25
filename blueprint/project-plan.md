# Project Plan

> User-owned plan. Edit this file directly whenever the product direction
> changes, then re-run `/overview`.

## 1. Problem - What problem are we solving?

The Pat Project is a short 3D first-person on-rails WWII shooter. You ride a
tank that never stops. The view creeps forward through countryside, trenches,
and a ruined town. Click to shoot. Dark and methodical, not chaotic.

A grey-box canoe fight and river clicks already shipped. They are a prior
experiment. The product is now this tank ride, dressed with the POLYGON WAR
pack.

## 2. Users - Who is this for?

- **Now:** you, playing in the Godot editor and building the ride.
- **Later:** a Windows zip for a friend, if export stays simple.
- Not a live service, not a web game, not Steam for this pass.

## 3. Features

### Shipped (superseded as the product)

- Grey-box canoe native fight and river flavor clicks. Keep them in git
  history. Do not keep them as the main scene once the tank ride exists.

### Now (this MVP)

- Locked first-person camera on a tank. Always moving. No look, no steer,
  no duck, no parked cover rooms.
- One rail: farm and hedges, then trenches and sandbags, then a ruined town.
  Terrain comes from `assets/POLYGON WAR/`.
- Reticle. Mouse left is always shoot.
- Soldiers along the path fire slow, visible projectiles (grenade, panzerfaust,
  mortar; not tiny bullets). Shoot the projectile or the thrower.
- Flavor props (barrels, crates, signs) also take a shot. Mostly audio or a
  small world reaction. Same click. No inventory.
- **3 health.** A hit subtracts 1. At 0, reload the whole tank ride.
- Boss stretch on the same rail in the town or at a bunker: denser, still
  moving, still the same click.
- Editor Play (F5) is how we verify. Windows zip last, only if it does not
  complicate the ride.

### Later (not this MVP)

- Continues / section restart
- Silent secrets (spare, idol)
- Cover / hold-to-duck / still rooms
- Puzzle hatches, extra branches
- Steam, web, level select

## 4. Data - What are we storing?

**Now (in-run, not saved):** `health` (int, max 3), `is_alive`,
`needs_restart`.

**Not now:** `current_section`, `continues_remaining`, `spared_natives`,
`has_idol`. No accounts, no server, no inventory.

## 5. Tech - What stack are we using?

- Godot 4 (`config_version=5`; editor reported 4.7)
- GDScript, typed
- 3D, first-person rail camera, reticle hitscan
- Asset library: `assets/POLYGON WAR/` (search by name, do not dump the pack)
- Main scene becomes the tank ride once it exists
- Verify in the editor (Play / F5)

## 6. Monetize - How will this make money?

None.

## 7. UI/UX - How should this look and feel?

Somber WWII ground war. Slow tank. Gun reticle. Click to fire. Small HP
readout. Hover may tint the reticle on a valid shot target. No cover prompt,
no inventory, no continue screen.

## 8. Deployment - Where and how will this ship?

- **Now:** Godot editor.
- **If it stays simple:** Windows executable, zip, send a link.
- If export fights us, stay editor-only until the ride is done.
- Repo: `DaveEstey/the-pat-project-v2`
- No Render/Vercel, no server.

## Explicit non-goals (this MVP)

- Canoe as the product start
- Time Crisis duck / peek / still stands
- A second click mode (interact vs shoot)
- Continues and full-run game over
- Silent secrets, puzzles, extra branches
- Driving the tank, camera look, Steam, web, level select

## Assumptions

- One click: shoot. Flavor props are shootable, not a second action.
- Incoming attacks are slow enough to read and shoot. Hitscan bullets at
  the player are out.
- Three hits restart the whole ride. That is not a continue screen.
- The POLYGON WAR pack is the look. Do not invent a second art style.

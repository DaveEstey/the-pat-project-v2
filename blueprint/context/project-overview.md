# The Pat Project - Project Overview

> 3D first-person on-rails jungle shooter. Active work is only the canoe native fight.

## Problem

The long-term game is a short, somber on-rails run (canoe, cover stands, tank,
boss, silent secrets). That slice is not the current problem.

Right now we only need one playable encounter: a canoe ride where natives throw
spears, you shoot the spear or the thrower, and death restarts the ride. Nothing
else ships until that loop works.

## Users

- **You (now)** - play the canoe scene in the Godot editor.
- **You, then a friend (later)** - finish the short game, then send a Windows
  download. No accounts or access tiers.
- Not a live service, web game, or Steam store page in this pass.

## Features

Headline for `/feature`: **1. Canoe native fight**. Items 2–11 wait until that
encounter is playable.

1. **Canoe native fight** - locked first-person camera rides the river; natives throw spears; shoot the spear or the thrower; death restarts the ride
2. **River clicks** - hover-click wildlife/props play audio; one teaching object shows the world is clickable
3. **Cover stands** - two stationary Time Crisis rooms after the boat
4. **Tank rail** - moving vehicle stretch, no cover, shoot threats
5. **Boss stand** - still cover fight with weak points and more health
6. **Silent secrets** - spare-natives flag helps at the boss; idol unlocks a secret ending
7. **Continues** - section restart with a continue limit, then full-run game over
8. **Windows download** - export a Windows build you can zip and send
9. **Puzzle beats** - hatch/latch clicks that change a route
10. **More branches** - extra silent routes beyond natives + idol
11. **Share polish** - icon, zip layout, friend-proof README for the download

## Data model

Nothing is persisted to disk for the canoe. In-run state only.

### CanoeRun (now)

- `is_alive` (bool) - false when a spear hits the player
- `needs_restart` (bool) - true after death; reloading the canoe scene clears it
- No health bar, no continue count, no save file

### Native (now, scene/runtime)

- `is_alive` (bool) - false if the player shot this thrower
- Throws `Spear` instances at the player while on-screen

### Spear (now, scene/runtime)

- In-flight projectile. Destroyed if shot. Kills the player on hit.
- Shooting the spear or its thrower both count as a successful defense

### RunProgress (later, do not implement in feature 1)

- `current_section` (enum/string) - canoe, cover_1, cover_2, tank, boss
- `continues_remaining` (int)
- `spared_natives` (bool) - true if no native was killed on the canoe
- `has_idol` (bool) - true if the idol was shot/collected

> Lock `spared_natives` and `has_idol` as flags for later features. Feature 1
> does not write them. Click is shoot-only in the canoe; interact-vs-shoot comes
> with River clicks.

## Tech stack

- **Godot 4** - engine (`config_version=5`; editor reported 4.7)
- **GDScript (typed)** - gameplay
- **3D scenes** - canoe, natives, spears, rail camera
- **First-person rail camera** - locked view, creeps forward, no free look
- **Reticle + click-to-shoot** - combat input
- **`assets/`** - WWII pack when present; placeholders allowed
- **Editor Play (F5)** - how we verify; no test runner yet

## Monetization

Not in this project. Hobby / send-a-build.

## UI/UX

Dark, slow river. Methodical, not chaotic. No cover HUD, no inventory, no
continue screen for the canoe.

- `res://scenes/` canoe encounter (main scene once set in `project.godot`) - the ride, reticle, shoot, die, restart
- Later: interact cursor on wildlife, hold-to-duck in still stands, small continue display, secret ending beat

> TODO: exact scene path and input-map names once they exist in `project.godot`.

## Deployment

- **Now:** Godot editor only. No export work until the canoe fight is playable.
- **Later:** Windows executable, zip, send a link.
- No Render/Vercel, no server, no env vars, no database.

## Open questions

- Cover button (hold-to-duck) is assumed in later cover stands, not specified as a key.
- Continue count for item 7 is not in the build-plan line; the earlier default was 3.
- `coding-standards.md` still has a 2D vs 3D TODO; the plans lock **3D**.
- Scene names, rail path, and spear hit rules (one hit = death) are feature-spec detail, not plan conflicts.

No disagreement on build order: item 1 is the only active feature.

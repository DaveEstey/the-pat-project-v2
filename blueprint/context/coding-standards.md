# Coding Standards

> Conventions for The Pat Project. Tuned for Godot 4 and GDScript during
> `/onboard`. Review before `/overview`.

## Engine and language

- Godot 4 (`config_version=5` in `project.godot`)
- GDScript unless the current spec says otherwise
- Do not add C# / .NET unless the user asks
- Typed GDScript: annotate parameters, return types, and member variables
- Prefer `class_name` on reusable types; keep autoloads few and named in
  `project.godot` when they exist
- Use `res://` for project files and `user://` for runtime user data
- Never hardcode machine-specific absolute paths

## Rendering and scenes

- Scenes are the composition unit. Prefer scene composition over giant scripts
- Keep node trees readable; name nodes for their role (`Player`, `Hurtbox`)
- Gameplay logic lives on the node that owns that behavior
- UI lives in Control scenes under `scenes/` (or a `ui/` subfolder when one exists)
- Shaders live in `shaders/` as `.gdshader` files

## Project structure

Match the layout in the product `README.md`:

- `scenes/` - `.tscn` scenes
- `scripts/` - GDScript (`.gd`) that is not embedded only in a scene
- `resources/` - custom resources and game data (`.tres`, resource scripts)
- `shaders/` - Godot shaders
- `assets/` - art, audio, fonts, models, textures, UI art
- `addons/` - Godot plugins
- `docs/` - design and technical notes

> TODO: confirm 2D vs 3D, main scene path, and input map once those exist in
> `project.godot`.

## Naming

- Classes / `class_name`: PascalCase (`PlayerController`)
- Nodes: PascalCase (`Hitbox`)
- Files: snake_case (`player_controller.gd`, `player.tscn`)
- Functions and variables: snake_case
- Constants and enum members: SCREAMING_SNAKE_CASE
- Signals: snake_case, past tense when they report an event (`health_changed`)

## Styling and presentation

- Theme and Control theming for UI, not ad-hoc per-control colors when a theme exists
- Keep placeholder colors local to the scene until an art pass exists
- Do not add a web CSS stack

> TODO: art direction, resolution, and stretch mode are not set yet.

## Data and persistence

- Game data that designers edit should be resources (`.tres`) or data files under
  `resources/`, not magic numbers scattered in scripts
- Save data belongs under `user://` when a save system exists

> TODO: save format, config, and any online services are not defined yet.

## Error handling

- Fail loud in development: `push_error` / `assert` for invariant breaks
- Do not swallow errors with empty `if err != OK` bodies
- User-facing failure should be a clear in-game message or UI state, not a
  debugger-only print, once UI exists
- Guard `get_node` paths; prefer `%UniqueName` or exported NodePaths over
  long fragile paths

## Testing

The blueprint installs no test runner; testing is opt-in at the project level,
because the overlay can't know your stack. Adding unit testing is an explicit
setup task the AI can do through the normal workflow, either as a build-plan item
or with `/tests`. The setup should choose the stack-native runner, wire the
scripts or commands, add a small example test, and update the Commands section
of `AGENTS.md`.

When `AGENTS.md` declares a `Verify` command, treat it as the umbrella automated
gate. It combines only the checks this project actually has. The command does not
enable an absent test runner or replace focused evidence. `/ci` owns Verify and
CI setup. `/tests` adds the real test command to Verify when it already exists,
but never creates CI only because testing was configured.

**The opt-in switch is one signal: a `test` command in the Commands section of
`AGENTS.md`.** Declare one and **tests become a gate for logic-bearing steps**,
not an optional extra; leave it out and the loop verifies logic with the evidence
it already uses (run the game, a screenshot of play mode, editor/export output).
Adding the runner is itself a deliberate step, never a silent mid-step install.
This is the single definition of the switch; the skills and `ai-interaction.md`
only point back here.

- **What to test (the scope rule):** pure logic where a wrong answer is possible -
  damage formulas, inventory rules, parsers, id builders, state machines with
  assertable inputs and outputs and real edge cases (empty, missing, malformed).
- **What not to test:** scene composition, animation, and full play-mode flows.
  Verify those by running the game in Godot and capturing a screenshot or short
  play notes, not brittle unit tests.
- **The gate (when a runner is configured):** a build step that adds in-scope logic
  must ship a passing test in the same reviewable diff. The project's test command
  must be green before the step is approved, before any checkpoint commit, and
  before `/complete` merges. Play-mode and integration-only steps are exempt and
  ride on screenshot plus run-game evidence.
- **When it's named:** the `/feature` spec's Testing section predicts the coverage,
  `/implement` writes the test with the step, and if a step surfaces logic the spec
  didn't foresee, add a focused test then.
- An empty suite should fail, not pass, so "no tests ran" never looks like "passed".
- Test files live next to source files (for example `health.gd` with `health_test.gd`
  once a runner exists).
- Run them via the project's test command (see Commands in `AGENTS.md`), not a
  hardcoded tool name.

Stack binding: no test runner is configured yet. A later `/tests` pass should pick
a Godot-native option (for example GUT) rather than a web/Node runner.

## Play-mode verification

For gameplay and UI behavior, prefer running the Godot project over reading the
code and assuming it works.

- Use the Commands in `AGENTS.md`: open the editor or `godot --path .`
- Capture screenshots of the game window, console errors from the editor Output
  panel, and notes on input that was pressed
- Do not add Playwright or a browser stack. This is not a web app
- Do not add a Godot test addon silently in the middle of an unrelated feature
- Play-mode evidence is especially important for movement, combat, UI navigation,
  scene changes, and anything that depends on `_process` / physics ticks

## Code Quality

- No commented-out code unless specified
- No unused imports, signals, or variables
- Keep functions under 50 lines when possible

## Comments

Write code that explains itself; comment only what the code cannot say.
Over-commenting is a common AI tell, so resist it.

- Comment the **why**, not the **what**. Delete any comment that restates the code.
- No banner/header blocks, section dividers, or step-by-step narration of obvious
  code. A file does not need a comment announcing each region.
- A comment earns its place only when it captures something the code can't: a
  non-obvious decision, a gotcha or workaround, why a value is what it is, or a
  link to a spec or issue.
- Prefer self-documenting names and small functions over explanatory comments.
- Keep doc comments minimal: a one-line purpose on an exported member is plenty
- When in doubt, leave the comment out.

## Writing

- No em dashes (U+2014) in generated content: docs, comments, commit messages,
  READMEs, specs. They read as AI-generated.
- Use a hyphen for `term - description` separators; rephrase prose with commas,
  parentheses, or a colon. Avoid en dashes and the ellipsis character too.

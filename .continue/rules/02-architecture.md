---
name: Architecture
alwaysApply: true
description: High-level systems, how they relate, and what is confirmed vs. unfinished/parked work.
---

# Architecture

## Composition over inheritance for actors
[scripts/character.gd](../../scripts/character.gd) — `class_name Character extends CharacterBody3D`
— is a thin base with only `@export var can_jump`. `Player`, `Dog`, `Mailman` extend it, but
**actual movement/input/camera logic lives in sibling Component nodes**, not in the subclasses.
See [06-components.md](06-components.md) and [04-character-movement.md](04-character-movement.md).
`Car` ([scripts/car.gd](../../scripts/car.gd)) does **not** extend `Character` and has its own
minimal, self-contained physics — don't unify it with the Character/Component system unless asked.

## Two independent kinds of State Machines (same generic engine, different purpose)
The generic `State`/`StateMachine` pair ([scripts/states/state.gd](../../scripts/states/state.gd),
[scripts/states/state_machine.gd](../../scripts/states/state_machine.gd)) is reused for:
1. **Per-character state machines** — `Player` (idle/running/jumping/immobile) and `Dog`
   (idle/escaping), each their own `StateMachine` node instance under the character scene.
2. **Game-flow state machine** — a separate `StateMachine` node directly under `Main`
   (`scenes/main.tscn`) with states `Paused → InHouse → OutsideHouse → Running`, controlling the
   overall scripted progression (mailman delivery → dog escape → chase → reality shift).

These are three fully independent `StateMachine` instances that never share `State` instances.
See [05-state-machine.md](05-state-machine.md) for details on adding states.

## Sequence system
[scripts/sequence.gd](../../scripts/sequence.gd) is a base `Node` with signal `finished` and a
virtual `start()`. Concrete sequences instanced under `Main/Sequences`:
- `MailmanSequence` — mailman walks a `PathFollow3D`, waits for player `interact`.
- `DogEscapeSequence` — chase choreography: dog escape trigger, mailman driven off, car spawner
  timer, `ChangeRealityArea` trigger, stop areas for player/dog.
Game-flow states reference sequences via `@export` + `NodePath` wired in the `.tscn`
(`InHouse.mailman_sequence`, `OutsideHouse.dog_escape_sequence`), not via runtime lookups.

## How nodes communicate (confirmed patterns only)
- **Area3D signals connected in the `.tscn`** (`[connection]` blocks in `main.tscn`) directly to
  sequence/state methods (e.g. `Level/Deadzone.body_entered → Main._on_deadzone_body_entered`).
- **`@export` + `NodePath`** configured in the editor for cross-branch references
  (`node_paths=PackedStringArray(...)` in `.tscn` files).
- **`%UniqueName`** lookups (`unique_name_in_owner`) for nodes inside the same owner scene.
- **Direct method calls** through the references above (`dog.start_escape()`, `player.stop()`,
  `mailman.remove_box()`).
There is **no event bus, no custom signal-broadcast singleton, and no project-defined autoload**
other than the addon's `PhantomCameraManager`. Do not introduce one to solve a wiring problem —
use the existing export/NodePath/%Unique conventions.

## WorldEnvironmentComponent = the "alternate reality" visual system
[scripts/components/world_environment.gd](../../scripts/components/world_environment.gd) tweens
fog/light/exposure presets (`normal`, `strange_1..3`). Triggered once by `DogEscapeSequence` when
the player enters `ChangeRealityArea`. This is the confirmed mechanism behind the reality shift
described in [AGENTS.md](../../AGENTS.md) — not a shader/post-process system.

## Confirmed unfinished / parked work — do not treat as active
- `FollowComponent` ([scripts/components/follow_component.gd](../../scripts/components/follow_component.gd))
  and the Dog `Following` state ([scripts/states/dog/following.gd](../../scripts/states/dog/following.gd))
  reference `dog.direction_to_follow`, a property **not present** on `Dog`
  ([scripts/dog.gd](../../scripts/dog.gd)). Neither `NavigationAgent3D` nor `FollowComponent` nor a
  `Following` state node exists in the currently saved `dog.tscn`/`main.tscn`. They only appear in
  an unsaved editor autosave file (`scenes/main.tscn####.tmp`). See [08-navigation.md](08-navigation.md).
- `TasksHUD` ([scripts/canvas_layer.gd](../../scripts/canvas_layer.gd)) is likewise not instantiated
  in any saved scene — same autosave-only status.
- `MovementComponent.movement_mode` enum and `_restrict_direction()` exist but are never called
  from any state. Não confirmado no código atual that axis-restricted movement is active anywhere.
- `CameraComponent.move_camera_to()` exists but has no confirmed call site.

---
name: Character Movement
globs:
  - "scripts/character.gd"
  - "scripts/player.gd"
  - "scripts/dog.gd"
  - "scripts/mailman.gd"
  - "scripts/car.gd"
  - "scripts/components/movement_component.gd"
  - "scripts/components/input_component.gd"
  - "scripts/states/player/**"
  - "scripts/states/dog/**"
description: How movement actually works for Player, Dog, Mailman, and Car — not the Godot default.
---

# Movement — as implemented (not a generic CharacterBody3D pattern)

## Shared base
[scripts/character.gd](../../scripts/character.gd): `class_name Character extends CharacterBody3D`
with only `@export var can_jump := true`. `Player`, `Dog`, `Mailman` extend it. `Mailman` does not
actually drive itself with physics (see below); `Car` does not extend `Character` at all.

## MovementComponent is the single source of truth for velocity
[scripts/components/movement_component.gd](../../scripts/components/movement_component.gd) is the
**only** place `body.velocity`/`move_and_slide()` should be touched for Player and Dog. States never
set velocity directly — they call `movement_component.move(input_dir: Vector2, delta)`. Confirmed in
every Player/Dog state that moves (`idle`, `running`, `jumping`, dog `running`).
- `move()` applies gravity first, converts the `Vector2` into a `Vector3` direction, optionally
  rotates it by the active camera's Y rotation when `use_camera_rotation = true` (Player only,
  Dog's instance has this off), accelerates `velocity.x/z` toward the target via `move_toward`,
  then calls `body.move_and_slide()`.
- `jump()` sets `velocity.y = jump_velocity` only if `body.is_on_floor() and body.can_jump`.
- `movement_mode` enum (`FREE/AXIS_X/AXIS_Z`) and `_restrict_direction()` exist but are **not called
  anywhere** — don't assume axis-restricted movement is active.
- Player and Dog each have their **own instance** of `MovementComponent` (same script, separate
  nodes) — it is not a shared/singleton node.

## Player input
Player owns a dedicated `InputComponent` child ([scenes/player.tscn](../../scenes/player.tscn)).
States read `input_component.input_direction` (Vector2 from `move_*` actions),
`is_jumping_pressed`, `is_interact_pressed`, `is_start_pressed` every `physics_update`. Never read
`Input.*` directly inside a Player/Dog state — go through `InputComponent`.

## Dog movement is procedural, not player-input-driven
Dog has **no `InputComponent`**. Its `Escaping` state (script
[scripts/states/dog/running.gd](../../scripts/states/dog/running.gd)) always calls
`movement_component.move(Vector2(1, 0), delta)` — i.e. constant "forward" in local space — and uses
two `RayCast3D` nodes unique-named `%CollisionAhead`/`%CollisionGround` in
[scenes/dog.tscn](../../scenes/dog.tscn) to auto-jump when the ground ray isn't hitting under it or
the ahead ray is blocked, while on floor. There is no navigation/pathfinding involved in this state
(see [08-navigation.md](08-navigation.md) for the separate, unfinished `FollowComponent` feature).

## Mailman
[scripts/mailman.gd](../../scripts/mailman.gd) doesn't use `MovementComponent`. Its position is
driven externally by tweening the `progress_ratio` of a `PathFollow3D`
(`%MailmanPathFollow3D` in `main.tscn`), from `MailmanSequence`/`OutsideHouse` game state.

## Car
[scripts/car.gd](../../scripts/car.gd) is a standalone `CharacterBody3D` (not `Character`) with its
own `_physics_process`: constant forward speed (`10.0`) along `direction` (set via
`set_direction()`), falls with gravity and frees itself if `velocity.y < -20.0`. It is spawned at
runtime by `DogEscapeSequence` from `car_scene` at randomly picked `car_spawner_markers`. Treat it
as an intentionally separate, simple system — don't route it through `MovementComponent`.

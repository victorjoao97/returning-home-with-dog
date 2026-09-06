---
name: Scenes and Nodes
globs: "scenes/**"
description: Confirmed scene composition, instancing relationships, and trigger/handoff conventions.
---

# Scenes and node organization

## Instancing relationships (confirmed)
- [scenes/main.tscn](../../scenes/main.tscn) instances: `Player` (under `PlayerGroup`), `Dog`
  (under `NPCs`), `Gate` (under `Level`), `Mailman` (under
  `NPCs/MailmanPath3D/MailmanPathFollow3D`). `Car` is **not** placed in the scene — it's
  `car_scene.instantiate()`'d at runtime by `DogEscapeSequence` at randomly chosen
  `Level/Cars/Marker3D*` positions.
- [scenes/after_accident.tscn](../../scenes/after_accident.tscn) instances `Player` and `Dog`
  directly (no state machine wiring shown beyond the base scenes) — this is the `next_scene` target
  of the `OutsideHouse` game state.
- [scenes/player.tscn](../../scenes/player.tscn) instances `Package` (hidden by default, shown via
  `Player.add_box()`). [scenes/mailman.tscn](../../scenes/mailman.tscn) also instances `Package`
  (removed via `Mailman.remove_box()`), representing the parcel changing hands during
  `DogEscapeSequence.start()`.

## `unique_name_in_owner` (`%Name`) usage
`main.tscn` marks many cross-referenced nodes unique in owner (e.g. `%Player`, `%Gate`,
`%MailmanPathFollow3D`, `%MovementComponent` per-actor, `%WorldEnvironmentComponent`,
`%InputComponent`, `%StopDogArea`/`%StopPlayerArea`/`%ChangeRealityArea`, `%SpawnDogOutside`,
`%MailmanArea`, `%OutsideHouse`). When adding a new node that needs to be referenced from a
different branch of the tree, mark it `unique_name_in_owner` in the scene and access it with
`%Name`, rather than hardcoding a long relative `NodePath`.

## Area3D-driven scripted triggers
Confirmed `[connection]` blocks in `main.tscn` wire `body_entered` directly to specific methods —
there is no generic "on_trigger" group/interface:
- `Level/Deadzone` → `Main._on_deadzone_body_entered` (reloads the scene).
- `Level/StopDogArea` / `Level/StopPlayerArea` / `Level/ChangeRealityArea` / `StartRunning` →
  methods on `Sequences/DogEscapeSequence`.
- `NPCs/DogArea` / `MailmanArea` → connected in code (`_ready()`) by the `Paused`/`MailmanSequence`
  scripts respectively, not via scene `[connection]` blocks.

## Scene handoff pattern
`OutsideHouse` game state holds `@export var next_scene: PackedScene` (currently
`after_accident.tscn`) and calls `get_tree().change_scene_to_packed.call_deferred(next_scene)` when
`DogEscapeSequence.finished` fires. This is the **only** confirmed scene-switching mechanism in the
project — there is no SceneTree/level-manager autoload. Follow this same pattern (exported
`PackedScene` + `change_scene_to_packed`) for any new scene transition.

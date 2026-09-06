---
name: Godot & GDScript Conventions
globs: "**/*.gd"
description: Coding conventions actually observed in this project's scripts (not generic Godot advice).
---

# Conventions observed in this codebase

- **Indentation with tabs**, `snake_case` for variables/functions, `PascalCase` for `class_name`
  and enums. Every reusable script starts with `class_name X extends Y` (e.g.
  [scripts/dog.gd](../../scripts/dog.gd), [scripts/components/movement_component.gd](../../scripts/components/movement_component.gd)).
  Not every script has a `class_name` — state scripts (`extends State`) and `main.gd`,
  `car.gd`, `camera_3d.gd` deliberately do not, since they're either one-off or instanced by scene
  path only.
- **Explicit typing**: exported vars, function params, and return types are typed
  (`func move(input_dir: Vector2, delta: float) -> void`). Keep this style in new/edited code.
- **`@export` for anything wired in the editor**, including cross-node references resolved as
  `NodePath` in the `.tscn` (`node_paths=PackedStringArray(...)`). Don't replace an existing
  `@export` reference with a runtime `get_node()`/`find_child()` call.
- **`@onready var x = %UniqueName`** is used only for nodes marked "Access as Unique Name" within
  the *same* scene (e.g. `%MovementComponent`, `%CollisionAhead`, `%Gate`). This coexists with the
  `@export NodePath` pattern above — `%Unique` is for same-scene internal lookups, `@export` is for
  references configured explicitly per-instance in the editor. Don't introduce hardcoded string
  paths like `get_node("../../Foo/Bar")` when either pattern already covers the need.
- **Getter-only computed properties**: `var x: T: get: return ...` is used for derived read-only
  values (`InputComponent.input_direction`, `MovementComponent.body_velocity`). Prefer this idiom
  over caching in `_process` for similar derived values.
- **Signals**: only two custom signals exist in the entire project —
  `State.switch_state(state: State)` and `Sequence.finished`. Both are declared once on their base
  class and reused by every subclass/instance. Don't redeclare a similar signal on a subclass;
  reuse the base one.
- **`@warning_ignore("unused_signal")`** is used in [scripts/states/state.gd](../../scripts/states/state.gd)
  to silence an expected warning — precedent for suppressing a specific known warning rather than
  removing/renaming the declaration.
- **`print`/`prints` debug statements** exist in shipped code (`state_machine.gd` logs every state
  transition, `dog_escape_sequence.gd` prints `"finished"`). This is an accepted existing pattern
  for lightweight debugging during prototyping — not something to "clean up" unless asked.
- **No Godot groups** (`add_to_group`/`is_in_group`/`[global_groups]`) are used anywhere in project
  code (only inside the third-party `phantom_camera` addon). Don't invent a new group when an
  existing `@export`/`%Unique` reference already provides the same node.
- **`class_name Sequence extends Node`** and **`class_name State extends Node`** are the only two
  "framework-like" base classes in the project. If a task looks like it needs a new base class for
  a family of behaviors, check whether `State` or `Sequence` already fits before creating one.

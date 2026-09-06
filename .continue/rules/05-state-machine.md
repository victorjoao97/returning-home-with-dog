---
name: State Machine
globs: "scripts/states/**"
description: How the generic State/StateMachine system works and how to extend it correctly.
---

# State / StateMachine system

Generic reusable pair, both `Node`-based:
- [scripts/states/state.gd](../../scripts/states/state.gd) — `class_name State extends Node`, only
  virtuals `enter()`, `exit()`, `update(delta)`, `physics_update(delta)`, plus signal
  `switch_state(state: State)`.
- [scripts/states/state_machine.gd](../../scripts/states/state_machine.gd) — `class_name
  StateMachine extends Node`. In `_ready()` it connects **every direct child State's**
  `switch_state` signal to its own `change_state`, then activates `initial_state` (an `@export`).
  `_process`/`_physics_process` forward to `active_state.update/physics_update` only if a state is
  active.

## How to add a new state (confirmed working pattern)
1. Add a new child `Node` under the target `StateMachine` node in the `.tscn`.
2. Attach a script `extends State`, implement only the virtuals actually needed.
3. Wire any references to sibling states/components as `@export` fields, resolved as `NodePath` in
   the scene (e.g. `running_state = NodePath("../Running")`, `movement_component` via `%Unique`).
4. To transition, call `switch_state.emit(target_state)` from inside the state — **never** call
   `state_machine.change_state()` directly from a state; the machine listens for the signal.

## Three independent StateMachine instances — do not cross-wire them
- **Player** ([scenes/player.tscn](../../scenes/player.tscn)): `Idle`, `Running`, `Jumping`,
  `Immobile` (node named "Immobile", script file is `static.gd` — name/file mismatch, confirmed).
- **Dog** ([scenes/dog.tscn](../../scenes/dog.tscn)): `Idle` (empty, no override), `Escaping`
  (script `scripts/states/dog/running.gd`, despite the node being named "Escaping" not "Running").
  `scripts/states/dog/following.gd` exists but has **no corresponding node** in the saved
  `dog.tscn` — não confirmado no código atual as an active state (see [08-navigation.md](08-navigation.md)).
- **Game flow** (top-level `StateMachine` under `Main` in [scenes/main.tscn](../../scenes/main.tscn)):
  `Paused → InHouse → OutsideHouse → Running`. This machine does not belong to a character; it
  drives the overall scripted progression (see [02-architecture.md](02-architecture.md)).

## `enabled` guard pattern (confirmed in some, not all, states)
Some states keep a local `var enabled := false`, set `true`/`false` in `enter()`/`exit()`, and
early-return in `physics_update()` when disabled: Player `Idle`, Player `Running`, Dog `Following`
(unused), game `Paused`. This is redundant with `StateMachine` only driving `active_state`, but it
is an existing defensive convention in this codebase — keep it when editing those states, don't
"simplify" it away as dead code without being asked.

## Cross-system references from states
Some states export references beyond sibling states — e.g. `Paused` exports `input_component`,
`in_house`, `dog_area`; `OutsideHouse` exports `dog_escape_sequence`, `mailman`, `next_scene`. This
is the same `@export` + `NodePath`-in-scene convention as everywhere else in the project — follow
it for any new cross-reference instead of `get_node("/root/...")` absolute lookups.

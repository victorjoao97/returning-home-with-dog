---
name: Navigation (unfinished feature — read before touching)
globs:
  - "scripts/components/follow_component.gd"
  - "scripts/states/dog/following.gd"
description: NavigationAgent3D/FollowComponent status — confirmed NOT wired into the saved project.
---

# Navigation status

**Not confirmed active in the current saved project.**

- [scripts/components/follow_component.gd](../../scripts/components/follow_component.gd)
  (`FollowComponent`, wraps a `NavigationAgent3D`) and
  [scripts/states/dog/following.gd](../../scripts/states/dog/following.gd) (a `Following` state
  that reads `dog.direction_to_follow`) exist as source files, but:
  - `Dog` ([scripts/dog.gd](../../scripts/dog.gd)) has **no `direction_to_follow` property** —
    `following.gd` would fail if it were ever entered as written.
  - The saved [scenes/dog.tscn](../../scenes/dog.tscn) has no `NavigationAgent3D` node and no
    `Following` state node under its `StateMachine`.
  - The saved [scenes/main.tscn](../../scenes/main.tscn) has no `FollowComponent` node.
  - A `NavigationAgent3D` under `NPCs/Dog` and a `FollowComponent` under `Components` **only**
    appear in an unsaved editor autosave file (`scenes/main.tscn####.tmp`) — this is editor
    crash-recovery/unsaved-work data, not part of the tracked project.

## What this means for any task touching dog-following/navigation
- Do not describe this as "an existing dog navigation system with a bug" — it is genuinely
  unfinished/parked work.
- Do not delete `follow_component.gd`/`following.gd` assuming they are dead/unused garbage without
  asking — they may be intentional in-progress work the user hasn't wired up yet.
- If asked to "fix" or "finish" dog following/navigation, confirm with the user whether to (a)
  finish wiring the existing `FollowComponent` + `NavigationAgent3D` + `Following` state, or (b) do
  something else, before writing code.
- The dog's actual current chase movement (`Escaping` state) does **not** use
  `NavigationAgent3D` at all — see [04-character-movement.md](04-character-movement.md).
- Não confirmado no código atual: whether any `NavigationRegion3D`/baked navmesh exists in
  `main.tscn`. Check the target scene directly before assuming one exists.

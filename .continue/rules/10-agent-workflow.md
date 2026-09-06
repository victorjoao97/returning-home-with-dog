---
name: Agent Workflow
alwaysApply: true
description: Mandatory investigation process, anti-hallucination rule, anti-rewrite rule, and error recovery for this project.
---

# How to work on this project

## 1. Investigate before writing any code
For every task, in this order:
1. Restate the request in your own words — what actor/system/scene does it touch?
2. Search for an existing system related to it first: check
   [02-architecture.md](02-architecture.md), [05-state-machine.md](05-state-machine.md),
   [06-components.md](06-components.md) for anything already covering this need.
3. Locate the concrete scripts and scenes involved (use search, don't guess file names).
4. Read the actual implementation of those files before proposing changes.
5. Look for references/dependencies: who instances the scene, who holds an `@export` reference to
   the node/script, which signals/`[connection]` blocks touch it.
6. Understand the current runtime flow end-to-end (which state/sequence calls what, in what order).
7. Only then propose a change — and prefer the **smallest change** that satisfies the request.
8. Reuse existing systems (`State`/`StateMachine`, `Sequence`, the components in
   [06-components.md](06-components.md)) instead of introducing new ones.
9. Validate the change (re-read the edited file, check for obvious reference/NodePath breakage,
   check `get_errors` when available).

## 2. Anti-hallucination rule
Never state that a file, system, component, signal, method, or scene exists without having found
concrete evidence for it in this project (via search/read, not memory of "typical Godot projects").
If something can't be confirmed, say explicitly **"Não confirmado no código atual"** instead of
guessing. Several parts of this project are *not* what a generic Godot project would suggest —
e.g. the Phantom Camera addon is installed but unused ([07-camera.md](07-camera.md)), and
`FollowComponent`/dog navigation exists in script form but isn't wired into any saved scene
([08-navigation.md](08-navigation.md)). Always verify against the actual saved files, not assumptions.

## 3. Anti-unnecessary-rewrite rule
Before creating any of the following, search the project first — if an equivalent already exists,
reuse/extend it instead of creating a parallel one:
- a new component (check [scripts/components/](../../scripts/components/) and [06-components.md](06-components.md));
- a new manager/singleton/autoload (none exist besides the addon's `PhantomCameraManager` — see [02-architecture.md](02-architecture.md));
- a new state machine (the generic `State`/`StateMachine` pair already exists — see [05-state-machine.md](05-state-machine.md));
- a new inter-node communication mechanism (use `@export`/`NodePath`, `%UniqueName`, or scene
  `[connection]` signals — see [03-godot-conventions.md](03-godot-conventions.md));
- a new movement/input/camera system (see [04-character-movement.md](04-character-movement.md) and
  [07-camera.md](07-camera.md)).
If you believe the existing architecture genuinely needs a structural change, explain **why**
before making it, and prefer the smallest structural change over a rewrite. Do not refactor working
code, rename things, or "clean up" prints/dead-looking flags as a side effect of an unrelated task.

## 4. Tool/command failure recovery
If a search, read, or command fails or returns nothing:
- Do not conclude the file/system doesn't exist from a single failed attempt.
- Analyze the error/empty-result and try a different tool or search strategy (different glob,
  different keyword, a broader directory, a different search pattern) before concluding absence.
- Do not repeat the exact same failing command/query again.
- Only report something as "not found" or "not confirmed" after a reasonable, varied attempt.
This is especially important for listing/searching/reading files — this project has at least one
misleading case already found: an unsaved editor autosave file
(`scenes/main.tscn####.tmp`) contains nodes/wiring that are **not** in the actual tracked
`scenes/main.tscn`. Always confirm against the real, saved scene file, and flag if you notice such
a `.tmp` autosave diverging from the tracked file.

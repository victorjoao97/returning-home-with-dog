---
name: Project Overview
alwaysApply: true
description: What this project is, its current stage, and its confirmed technical baseline.
---

# Returning Home with Dog — Overview

Narrative-exploration game (no combat) about a protagonist chasing an escaped dog into an
alternate reality that represents the protagonist's consciousness. The dog is a spiritual
guide, not a GPS. Full narrative context: [AGENTS.md](../../AGENTS.md) and
[README.md](../../README.md).

**Current production stage: prototipação inicial.** Priorities per [AGENTS.md](../../AGENTS.md):
radical mechanic simplification, validating flow (chase → reality shift → dog-guided return),
reuse of existing basic systems, small isolated micro-levels, "dirty but functional" code is
acceptable. Do not introduce new systems/managers/abstractions to chase polish at this stage.

## Confirmed technical baseline
- Engine: Godot **4.7** (`config/features` in [project.godot](../../project.godot)), GDScript,
  physics engine **Jolt Physics** (`3d/physics_engine="Jolt Physics"`).
- Main scene: [scenes/main.tscn](../../scenes/main.tscn) (script [scripts/main.gd](../../scripts/main.gd),
  which currently only reloads the scene on `Deadzone` trigger — it is not a general "game manager").
- Autoload: `PhantomCameraManager` (from the `phantom_camera` addon). **Confirmed installed and
  autoloaded, but no `PhantomCamera2D`/`PhantomCamera3D` node exists in any project scene.** The
  actual camera system is `SpringArm3D` + `Camera3D` + `CameraComponent` (see
  [07-camera.md](07-camera.md)). Don't assume Phantom Camera drives gameplay camera.
- Input actions (see `[input]` in [project.godot](../../project.godot)): `move_up/down/left/right`,
  `jump`, `exit`, `interact`, `start`.
- Collision layers (`[layer_names]` in [project.godot](../../project.godot)):
  `1=ground, 2=player, 3=dog, 4=obstacules, 5=deadzone`. Use these names when reasoning about
  `collision_layer`/`collision_mask` values instead of guessing.

## Directory roles (confirmed by inspection)
- [scripts/](../../scripts/) — root behavior scripts, one per scene-level actor (`character.gd`,
  `player.gd`, `dog.gd`, `mailman.gd`, `car.gd`, `gate.gd`, `main.gd`, `camera_3d.gd`, `canvas_layer.gd`).
- [scripts/components/](../../scripts/components/) — reusable composition units attached as child
  `Node`s (movement, input, camera, world-environment, follow). See [06-components.md](06-components.md).
- [scripts/states/](../../scripts/states/) — generic `State`/`StateMachine` base classes plus
  per-actor state folders `dog/`, `game/`, `player/`. See [05-state-machine.md](05-state-machine.md).
- [scripts/sequences/](../../scripts/sequences/) — scripted event sequences extending `Sequence`
  (`MailmanSequence`, `DogEscapeSequence`). See [02-architecture.md](02-architecture.md).
- [scenes/](../../scenes/), [resources/](../../resources/) (`.tres`/`.res` materials & animations),
  [assets/](../../assets/) (audio, prototype textures, reference images).
- [addons/phantom_camera/](../../addons/phantom_camera/) — third-party addon, enabled in
  `project.godot`, but not wired into any gameplay scene as confirmed above.

Não confirmado no código atual: any content/level design beyond what exists in `scenes/main.tscn`
and `scenes/after_accident.tscn` (no other level scenes exist in the repo).

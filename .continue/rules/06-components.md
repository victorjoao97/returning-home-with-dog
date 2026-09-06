---
name: Components
globs: "scripts/components/**"
description: What each component is responsible for, and the reuse-first rule for new behavior.
---

# Components

Components are plain `Node`s added as children of the owning actor/`Main`, exposed to others via
`@export NodePath` or `%UniqueName`. There is **no shared base "Component" class** — each is a
standalone script. Before adding a new component, check this list; most character needs already
have one.

- **`InputComponent`** ([input_component.gd](../../scripts/components/input_component.gd)) — the
  only place that should read the `Input` singleton for gameplay actions (`move_*`, `jump`,
  `interact`, `start`). Exposes computed getter properties and joypad-vibration helper
  (`handle_vibration()`, gated by `joy_vibration`). Read input through this component, not
  `Input.*` directly, in any new Player/Dog code.
- **`MovementComponent`** ([movement_component.gd](../../scripts/components/movement_component.gd))
  — single source of truth for gravity + horizontal acceleration + `move_and_slide()`. Same script
  used by both Player and Dog, each with its own instance. See [04-character-movement.md](04-character-movement.md).
- **`CameraComponent`** ([camera_component.gd](../../scripts/components/camera_component.gd)) —
  owns mouse-look (rotates an exported `spring_arm`), toggling `Input.mouse_mode` on left-click /
  the `exit` action. **Documented exception**: this is the one place allowed to read `Input`/mouse
  events directly instead of going through `InputComponent`. Also has `move_camera_to(target:
  Marker3D)` (tween-based reposition) — no confirmed call site, don't assume it's used.
- **`WorldEnvironmentComponent`** ([world_environment.gd](../../scripts/components/world_environment.gd))
  — owns the "alternate reality" visual transition (fog/light/exposure presets tweened via
  `enter_strange_reality()`), operating on exported `WorldEnvironment` + `DirectionalLight3D`.
  Triggered once by `DogEscapeSequence` on `ChangeRealityArea` entry.
- **`FollowComponent`** ([follow_component.gd](../../scripts/components/follow_component.gd)) —
  wraps a `NavigationAgent3D` to compute a follow direction toward a `target`, stopping within
  `follow_distance`. **Not wired into any currently saved scene** — see [08-navigation.md](08-navigation.md)
  before touching this or assuming it's active.

## Rule
If a task needs "the dog/player to move", "to read input", "to change lighting/fog", or "to follow
a target" — look here first and extend the matching component instead of writing new logic inline
in a state or creating a parallel component.

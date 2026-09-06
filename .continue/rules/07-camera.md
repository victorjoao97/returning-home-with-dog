---
name: Camera
globs:
  - "scripts/camera_3d.gd"
  - "scripts/components/camera_component.gd"
  - "scenes/player.tscn"
  - "scenes/main.tscn"
description: The real, confirmed camera architecture — SpringArm3D + CameraComponent, not Phantom Camera.
---

# Camera architecture (confirmed)

- Player owns a `SpringArm3D` (`spring_length = 3.0`) with a child `Camera3D`
  ([scenes/player.tscn](../../scenes/player.tscn)). That `Camera3D` has script
  [scripts/camera_3d.gd](../../scripts/camera_3d.gd) — its entire body is commented out. **This
  script currently does nothing at runtime.** Don't assume mouse-look/rotation logic lives there.
- Actual camera control lives in **`CameraComponent`**
  ([scripts/components/camera_component.gd](../../scripts/components/camera_component.gd)), a
  sibling component under `Main/Components`, wired as
  `spring_arm = NodePath("../../PlayerGroup/Player/SpringArm3D")`. On left mouse click it captures
  the mouse and rotates the `SpringArm3D` (`rotation.y` wrapped, `rotation.x` clamped to
  `[-PI/2, PI/4]`) from `InputEventMouseMotion`; the `exit` action releases the mouse.
- In [scenes/main.tscn](../../scenes/main.tscn), `CameraComponent.follow_mouse` is set to `true` on
  the instance, so mouse-look is enabled by default in that scene even though the component's own
  `_ready()` only captures the mouse if `follow_mouse` was already true at that point.
- `PhantomCameraManager` is autoloaded and the `phantom_camera` addon is enabled in
  `project.godot`, but **no `PhantomCamera2D`/`PhantomCamera3D` node exists in any project scene**
  (main.tscn, player.tscn, dog.tscn, after_accident.tscn all checked). Do not migrate camera logic
  to Phantom Camera nodes unless explicitly asked — the confirmed active system is
  SpringArm3D + Camera3D + CameraComponent.

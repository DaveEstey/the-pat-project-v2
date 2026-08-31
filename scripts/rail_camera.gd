extends PathFollow3D

## Moves the first-person camera along a Path3D. No look, no steer.

@export var speed: float = 2.0

func _ready() -> void:
	loop = false
	rotation_mode = ROTATION_Y
	progress_ratio = 0.0


func _process(delta: float) -> void:
	if progress_ratio >= 1.0:
		progress_ratio = 1.0
		return
	progress += speed * delta

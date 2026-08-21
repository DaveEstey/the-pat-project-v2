class_name NativeThrower
extends Node3D

## Grey-box thrower. Tosses spears at the camera while on-screen.

@export var spear_scene: PackedScene
@export var throw_interval: float = 1.7
@export var muzzle: Marker3D

var is_alive: bool = true
var _cooldown: float = 0.4

@onready var _on_screen: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D


func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	_cooldown -= delta
	if _cooldown > 0.0:
		return
	if _on_screen == null or not _on_screen.is_on_screen():
		return
	_throw()
	_cooldown = throw_interval


func _throw() -> void:
	if spear_scene == null:
		return
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var spear := spear_scene.instantiate() as Spear
	if spear == null:
		return
	get_tree().current_scene.add_child(spear)
	var from: Vector3 = global_position + Vector3(0.0, 1.2, 0.0)
	if muzzle != null:
		from = muzzle.global_position
	spear.setup(from, camera.global_position)

class_name Soldier
extends Node3D

## Fires slow grenades at the camera while alive and on-screen.

@export var projectile_scene: PackedScene
@export var throw_interval: float = 2.4
@export var muzzle: Marker3D

var is_alive: bool = true
var _cooldown: float = 0.8

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


func take_shot() -> void:
	down()


func down() -> void:
	if not is_alive:
		return
	is_alive = false
	var body := get_node_or_null("Body") as CollisionObject3D
	if body != null:
		body.collision_layer = 0
		body.collision_mask = 0
	visible = false


func _throw() -> void:
	if projectile_scene == null:
		return
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var proj: Node = projectile_scene.instantiate()
	if proj == null or not proj.has_method("setup"):
		return
	get_tree().current_scene.add_child(proj)
	var from: Vector3 = global_position + Vector3(0.0, 1.4, 0.0)
	if muzzle != null:
		from = muzzle.global_position
	proj.call("setup", from, camera.global_position)

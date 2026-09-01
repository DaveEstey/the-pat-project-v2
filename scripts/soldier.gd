class_name Soldier
extends Node3D

## Fires slow grenades at the camera while armed, alive, and on-screen.

const COLLISION_LAYER_SHOOTABLE: int = 8

@export var projectile_scene: PackedScene
@export var throw_interval: float = 2.4
@export var muzzle: Marker3D

var is_alive: bool = true
var _armed: bool = false
var _cooldown: float = 0.8

@onready var _on_screen: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D


func _ready() -> void:
	if not _armed:
		_set_body_shootable(false)


func _physics_process(delta: float) -> void:
	if not _armed or not is_alive:
		return
	_cooldown -= delta
	if _cooldown > 0.0:
		return
	if _on_screen == null or not _on_screen.is_on_screen():
		return
	_throw()
	_cooldown = throw_interval


func activate() -> void:
	if _armed or not is_alive:
		return
	_armed = true
	if is_node_ready():
		_set_body_shootable(true)
	else:
		call_deferred("_set_body_shootable", true)


func take_shot() -> void:
	down()


func down() -> void:
	if not is_alive:
		return
	is_alive = false
	_set_body_shootable(false)
	visible = false


func _set_body_shootable(enabled: bool) -> void:
	var body := get_node_or_null("Body") as CollisionObject3D
	if body == null:
		return
	body.collision_layer = COLLISION_LAYER_SHOOTABLE if enabled else 0
	body.collision_mask = 0


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

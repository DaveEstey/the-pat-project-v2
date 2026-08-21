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
	var spear: Node = spear_scene.instantiate()
	if spear == null or not spear.has_method("setup"):
		return
	get_tree().current_scene.add_child(spear)
	var from: Vector3 = global_position + Vector3(0.0, 1.2, 0.0)
	if muzzle != null:
		from = muzzle.global_position
	spear.call("setup", from, camera.global_position)


func down() -> void:
	if not is_alive:
		return
	is_alive = false
	var mesh := get_node_or_null("Mesh") as MeshInstance3D
	if mesh != null:
		var dark := StandardMaterial3D.new()
		dark.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		dark.albedo_color = Color(0.28, 0.28, 0.3, 1)
		mesh.set_surface_override_material(0, dark)
	var body := get_node_or_null("Body") as CollisionObject3D
	if body != null:
		body.collision_layer = 0
		body.collision_mask = 0

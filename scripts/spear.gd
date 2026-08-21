class_name Spear
extends Area3D

## Grey-box spear. Tracks the moving camera. Hits cost health, deferred.

@export var speed: float = 9.0
@export var lifetime: float = 5.0
@export var hit_range: float = 1.2

var _direction: Vector3 = Vector3.FORWARD
var _age: float = 0.0
var _spent: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func setup(from: Vector3, toward: Vector3) -> void:
	global_position = from
	_aim_at(toward)


func _physics_process(delta: float) -> void:
	if _spent:
		return
	var camera := get_viewport().get_camera_3d()
	if camera != null:
		var to_camera: Vector3 = camera.global_position - global_position
		if to_camera.length() <= hit_range:
			_hit_player()
			return
		_aim_at(camera.global_position)
	global_position += _direction * speed * delta
	_age += delta
	if _age >= lifetime:
		queue_free()


func _aim_at(toward: Vector3) -> void:
	var offset: Vector3 = toward - global_position
	if offset.length_squared() < 0.001:
		return
	_direction = offset.normalized()
	if absf(_direction.dot(Vector3.UP)) < 0.98:
		look_at(global_position + _direction, Vector3.UP)


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		_hit_player()


func _hit_player() -> void:
	if _spent:
		return
	_spent = true
	var run: Node = get_tree().current_scene
	if run != null and run.has_method("take_hit"):
		run.call_deferred("take_hit")
	call_deferred("queue_free")

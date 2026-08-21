class_name Spear
extends Area3D

## Grey-box spear. Flies toward a point, then despawns. No player damage yet.

@export var speed: float = 9.0
@export var lifetime: float = 5.0

var _direction: Vector3 = Vector3.FORWARD
var _age: float = 0.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func setup(from: Vector3, toward: Vector3) -> void:
	global_position = from
	var offset: Vector3 = toward - from
	if offset.length_squared() < 0.001:
		_direction = Vector3.FORWARD
	else:
		_direction = offset.normalized()
	look_at(global_position + _direction, Vector3.UP)


func _physics_process(delta: float) -> void:
	global_position += _direction * speed * delta
	_age += delta
	if _age >= lifetime:
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	if not area.is_in_group("player"):
		return
	var run := get_tree().current_scene as CanoeRun
	if run != null:
		run.die()
	queue_free()

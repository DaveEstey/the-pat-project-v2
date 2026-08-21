extends Node

## Screen-space reticle and click hitscan. Camera stays locked on the rail.

@export var camera: Camera3D
@export var reticle: Control
@export var dummy: Node3D
@export var ray_length: float = 200.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_ensure_shoot_action()


func _process(_delta: float) -> void:
	if reticle == null:
		return
	var half: Vector2 = reticle.size * 0.5
	reticle.position = get_viewport().get_mouse_position() - half


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot()
		get_viewport().set_input_as_handled()


func _ensure_shoot_action() -> void:
	if InputMap.has_action("shoot"):
		return
	InputMap.add_action("shoot")
	var mouse_button := InputEventMouseButton.new()
	mouse_button.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("shoot", mouse_button)


func _shoot() -> void:
	if camera == null:
		return
	var mouse: Vector2 = get_viewport().get_mouse_position()
	var origin: Vector3 = camera.project_ray_origin(mouse)
	var toward: Vector3 = camera.project_ray_normal(mouse)
	var query := PhysicsRayQueryParameters3D.create(origin, origin + toward * ray_length)
	var hit: Dictionary = camera.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return
	var collider := hit.collider as Node
	if collider != null and dummy != null and (
		collider == dummy or dummy.is_ancestor_of(collider) or collider.is_in_group("hit_dummy")
	):
		dummy.visible = false
		_disable_dummy_collision()


func _disable_dummy_collision() -> void:
	if dummy == null:
		return
	for child: Node in dummy.find_children("*", "CollisionObject3D", true, false):
		(child as CollisionObject3D).collision_layer = 0
		(child as CollisionObject3D).collision_mask = 0

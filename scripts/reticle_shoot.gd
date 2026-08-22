extends Node

## Screen-space reticle and click hitscan. Camera stays locked on the rail.
## Mask skips the player hurtbox (layer 4) so shots reach spears and natives.

const RAY_MASK: int = 1 | 2 | 8
const RETICLE_IDLE := Color(0.12, 0.12, 0.12, 1)
const RETICLE_HOVER := Color(0.82, 0.62, 0.2, 1)

@export var camera: Camera3D
@export var reticle: Control
@export var dummy: Node3D
@export var ray_length: float = 200.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_ensure_shoot_action()
	_resolve_exports()


func _process(_delta: float) -> void:
	if reticle == null:
		return
	var half: Vector2 = reticle.size * 0.5
	reticle.position = get_viewport().get_mouse_position() - half
	_update_hover_tint()


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


func _resolve_exports() -> void:
	var root: Node = owner if owner != null else get_parent()
	if camera == null and root != null:
		camera = root.get_node_or_null("%Camera3D") as Camera3D
	if reticle == null and root != null:
		reticle = root.get_node_or_null("%Reticle") as Control
	if dummy == null and root != null:
		dummy = root.get_node_or_null("%Dummy") as Node3D


func _update_hover_tint() -> void:
	var hovering := _hover_interactable() != null
	_set_reticle_color(RETICLE_HOVER if hovering else RETICLE_IDLE)


func _hover_interactable() -> Node:
	var hit: Dictionary = _intersect_mouse(RAY_MASK)
	if hit.is_empty():
		return null
	var collider := hit.collider as Node
	if collider == null:
		return null
	return _find_group_ancestor(collider, "interactable")


func _set_reticle_color(color: Color) -> void:
	if reticle == null:
		return
	for child: Node in reticle.get_children():
		var bar := child as ColorRect
		if bar != null:
			bar.color = color


func _intersect_mouse(mask: int) -> Dictionary:
	if camera == null:
		_resolve_exports()
	if camera == null:
		return {}
	var mouse: Vector2 = get_viewport().get_mouse_position()
	var origin: Vector3 = camera.project_ray_origin(mouse)
	var toward: Vector3 = camera.project_ray_normal(mouse)
	var query := PhysicsRayQueryParameters3D.create(origin, origin + toward * ray_length)
	query.collide_with_areas = true
	query.collision_mask = mask
	return camera.get_world_3d().direct_space_state.intersect_ray(query)


func _shoot() -> void:
	var run := owner as CanoeRun
	if run != null and not run.is_alive:
		return
	var hit: Dictionary = _intersect_mouse(RAY_MASK)
	if hit.is_empty():
		return
	var collider := hit.collider as Node
	if collider == null:
		return
	var clicked: Node = _find_group_ancestor(collider, "interactable")
	if clicked != null and clicked.has_method("interact"):
		clicked.call("interact")
		return
	if dummy != null and (
		collider == dummy or dummy.is_ancestor_of(collider) or collider.is_in_group("hit_dummy")
	):
		dummy.visible = false
		_disable_dummy_collision()
		return
	var spear: Node = _find_group_ancestor(collider, "spear")
	if spear != null:
		spear.queue_free()
		return
	var thrower: Node = _find_group_ancestor(collider, "native")
	if thrower != null and thrower.has_method("down"):
		thrower.call("down")


func _find_group_ancestor(node: Node, group: String) -> Node:
	var current: Node = node
	while current != null:
		if current.is_in_group(group):
			return current
		current = current.get_parent()
	return null


func _disable_dummy_collision() -> void:
	if dummy == null:
		return
	for child: Node in dummy.find_children("*", "CollisionObject3D", true, false):
		(child as CollisionObject3D).collision_layer = 0
		(child as CollisionObject3D).collision_mask = 0

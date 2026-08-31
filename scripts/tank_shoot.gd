extends Node

## Screen-space reticle and click hitscan on the tank ride. Camera stays locked.

const RAY_MASK: int = 2 | 8
const RETICLE_IDLE := Color(0.12, 0.12, 0.12, 1)
const RETICLE_HOVER := Color(0.82, 0.62, 0.2, 1)

@export var camera: Camera3D
@export var reticle: Control
@export var dummy: Node3D
@export var ray_length: float = 200.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_resolve_exports()


func _process(_delta: float) -> void:
	if reticle == null:
		_resolve_exports()
	if reticle == null:
		return
	var half: Vector2 = reticle.size * 0.5
	reticle.position = get_viewport().get_mouse_position() - half
	_update_hover_tint()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot()
		get_viewport().set_input_as_handled()


func _resolve_exports() -> void:
	var root: Node = owner if owner != null else get_parent()
	if root == null:
		return
	if camera == null:
		camera = root.get_node_or_null("%Camera3D") as Camera3D
	if reticle == null:
		reticle = root.get_node_or_null("%Reticle") as Control
	if dummy == null:
		dummy = root.get_node_or_null("%Dummy") as Node3D


func _update_hover_tint() -> void:
	var hovering := _hover_shot_target() != null
	_set_reticle_color(RETICLE_HOVER if hovering else RETICLE_IDLE)


func _hover_shot_target() -> Node:
	var hit: Dictionary = _intersect_mouse(RAY_MASK)
	if hit.is_empty():
		return null
	var collider := hit.collider as Node
	if collider == null:
		return null
	return _resolve_shot_target(collider)


func _set_reticle_color(color: Color) -> void:
	if reticle == null:
		return
	for child: Node in reticle.get_children():
		var bar := child as ColorRect
		if bar != null:
			bar.color = color


func _shoot() -> void:
	var run := owner as TankRun
	if run != null and not run.is_alive:
		return
	var hit: Dictionary = _intersect_mouse(RAY_MASK)
	if hit.is_empty():
		return
	var collider := hit.collider as Node
	if collider == null:
		return
	var target: Node = _resolve_shot_target(collider)
	if target != null and target.has_method("take_shot"):
		target.take_shot()


func _resolve_shot_target(collider: Node) -> Node:
	if dummy != null and dummy.visible:
		if collider == dummy or dummy.is_ancestor_of(collider):
			return dummy
	var grouped: Node = _find_group_ancestor(collider, "shot_target")
	if grouped != null:
		return grouped
	return null


func _intersect_mouse(mask: int) -> Dictionary:
	_resolve_exports()
	if camera == null:
		return {}
	var mouse: Vector2 = get_viewport().get_mouse_position()
	var origin: Vector3 = camera.project_ray_origin(mouse)
	var toward: Vector3 = camera.project_ray_normal(mouse)
	var query := PhysicsRayQueryParameters3D.create(origin, origin + toward * ray_length)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = mask
	return camera.get_world_3d().direct_space_state.intersect_ray(query)


func _find_group_ancestor(node: Node, group: String) -> Node:
	var current: Node = node
	while current != null:
		if current.is_in_group(group):
			return current
		current = current.get_parent()
	return null

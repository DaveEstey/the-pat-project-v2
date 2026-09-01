class_name CombatCheckpoint
extends Area3D

## One-shot trigger: arms every Soldier in wave_group when the hurtbox overlaps.

@export var wave_group: StringName = &""

var _fired: bool = false


func _ready() -> void:
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 4
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	if _fired:
		return
	if area == null or not area.is_in_group("player"):
		return
	if wave_group == &"":
		push_error("CombatCheckpoint missing wave_group on %s" % name)
		return
	_fired = true
	for node: Node in get_tree().get_nodes_in_group(wave_group):
		if node.has_method("activate"):
			node.call("activate")
	set_deferred("monitoring", false)

class_name TankRun
extends Node3D

## In-run tank ride state. Three hits will reload this scene in a later feature.

@export var max_health: int = 3

var is_alive: bool = true
var needs_restart: bool = false
var health: int = 3


func _ready() -> void:
	health = max_health
	_refresh_health_label()


func take_hit() -> void:
	if not is_alive:
		return
	health -= 1
	_refresh_health_label()
	if health <= 0:
		die()


func die() -> void:
	if not is_alive:
		return
	is_alive = false
	needs_restart = true
	get_tree().call_deferred("reload_current_scene")


func _refresh_health_label() -> void:
	var label := get_node_or_null("%HealthLabel") as Label
	if label != null:
		label.text = "HP %d/%d" % [maxi(health, 0), max_health]

class_name CanoeRun
extends Node3D

## In-run canoe state. A spear hit reloads this scene.

var is_alive: bool = true
var needs_restart: bool = false


func die() -> void:
	if not is_alive:
		return
	is_alive = false
	needs_restart = true
	get_tree().reload_current_scene()

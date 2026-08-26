extends Node3D

## Practice shot target for the tank hitscan. Feature 14 will reuse `shot_target`.


func take_shot() -> void:
	visible = false
	for child: Node in find_children("*", "CollisionObject3D", true, false):
		var body := child as CollisionObject3D
		body.collision_layer = 0
		body.collision_mask = 0

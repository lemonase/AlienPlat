extends KinematicBody2D


export(int) var DAMAGE = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.hit(position.x, DAMAGE)

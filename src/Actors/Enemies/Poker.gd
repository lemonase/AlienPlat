extends KinematicBody2D

export(int) var DAMAGE = 1

func _ready():
	pass


func _physics_process(_delta):
	pass


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.hit(position.x, DAMAGE)

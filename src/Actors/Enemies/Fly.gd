extends KinematicBody2D

var direction
var velocity

export var SPEED = 50


func _ready():
	direction = 1
	velocity = Vector2.ZERO


func flip_direction():
	direction *= -1
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h


func _physics_process(_delta):
	if is_on_wall():
		flip_direction()

	velocity.x = SPEED * direction
	$AnimatedSprite.play("fly")

	velocity = move_and_slide(velocity)

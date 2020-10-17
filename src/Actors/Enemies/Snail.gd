extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
export var SPEED = 50

var direction
var velocity

func _ready():
	direction = 1
	velocity = Vector2.ZERO


func flip_direction():
	direction *= -1
	$RayCast2D.position.x *= -1
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h


func _physics_process(_delta):
	if is_on_wall():
		flip_direction()
	if not $RayCast2D.is_colliding():
		flip_direction()

	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)


func _on_TopHitbox_body_entered(body):
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true

	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)

	$TopHitbox.set_collision_mask_bit(1, false)
	$TopHitbox.set_collision_layer_bit(2, false)
	SPEED = 0

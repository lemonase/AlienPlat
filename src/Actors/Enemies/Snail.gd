extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
export(int) var SPEED = 50
export(int) var DAMAGE = 1

var direction
var velocity

var hidden

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


func die():
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	$SidesHitbox/CollisionShape2D.disabled = true
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	$TopHitbox.set_collision_mask_bit(1, false)
	$TopHitbox.set_collision_layer_bit(2, false)
	$SidesHitbox.set_collision_mask_bit(1, false)
	$SidesHitbox.set_collision_layer_bit(2, false)
	SPEED = 0


func _on_TopHitbox_body_entered(body):
	if body.name == "Player":
		if !hidden:
			die()
		body.bounce()


func _on_SidesHitbox_body_entered(body):
	if body.name == "Player":
		body.hit(position.x, DAMAGE)


func _on_PlayerDetectionBox_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite.play("hide")
		hidden = true
		SPEED = 0


func _on_PlayerDetectionBox_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite.play("walk")
		hidden = false
		SPEED = 50

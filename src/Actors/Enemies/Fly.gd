extends KinematicBody2D

var direction
var velocity

export(int) var SPEED = 50
export(int) var DAMAGE = 2

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
	velocity = move_and_slide(velocity)


func die():
	$AnimatedSprite.play("dead")

	if not is_on_floor():
		velocity.y = SPEED

	$CollisionShape2D.disabled = true
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	$TopHitbox.set_collision_mask_bit(1, false)
	$TopHitbox.set_collision_layer_bit(2, false)
	SPEED = 0


func _on_TopHitbox_body_entered(body):
	die()
	if body.name == "Player":
		body.bounce()


func _on_SideBottomHitbox_body_entered(body):
	if body.name == "Player":
		body.hit(position.x, DAMAGE)

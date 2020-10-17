extends KinematicBody2D

# x speed
export(int) var CURRENT_SPEED = 400
export(int) var MIN_SPEED = 400
export(int) var MAX_SPEED = 800
export(int) var SPEED_INC_RATE = 100

# y speed
export(int) var JUMP_FORCE = 400
export(int) var HIT_FORCE = JUMP_FORCE * 3
export(int) var GRAVITY = 10

# constants
const FLOOR = Vector2(0, -1)

# player velocity/direction
var velocity = Vector2.ZERO
var x_direction = 1

# health
export var health = 5
var alive = true
const ENEMY_LAYER = 4
var hit_timer


func _ready():
	scale = scale * .70
	create_hit_timer()


func _physics_process(_delta):
	if alive:
		handle_input()
		move_character()
		check_collisions()
		check_health()
	else:
		set_modulate(Color(0.1,0.1,0.1,.02))
		velocity.x = 0
		velocity.y = 0


func create_hit_timer():
	hit_timer = Timer.new()
	hit_timer.connect("timeout", self, "on_hit_timer_timeout")
	hit_timer.one_shot = true
	add_child(hit_timer)


# moves character
func move_character():
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)


# emit collided signals
func check_collisions():
	for i in get_slide_count():
		var c = get_slide_collision(i)
		var layer = c.collider.get("collision_layer")

		if layer == ENEMY_LAYER:
			# print("Collision Layer: ", layer)
			hit_timer.start()


func handle_input():
	# y-axis translation
	check_up_and_down()

	# x-axis and idle
	check_left_or_right()


# movement functions
func check_up_and_down():
	if Input.is_action_pressed("ui_up"):
		velocity.y = -JUMP_FORCE
	if Input.is_action_pressed("ui_down"):
		velocity.y = JUMP_FORCE
	if velocity.y < 0:
		$AnimatedSprite.play("jump")
	elif velocity.y > 0:
		$AnimatedSprite.play("fall")


func check_left_or_right():
	if Input.is_key_pressed(KEY_SHIFT):
	# shift = speed up
		if CURRENT_SPEED <= MAX_SPEED:
			CURRENT_SPEED += SPEED_INC_RATE
			$AnimatedSprite.set_speed_scale(2)
	else:
		if CURRENT_SPEED >= MIN_SPEED:
			CURRENT_SPEED -= SPEED_INC_RATE
			$AnimatedSprite.set_speed_scale(1)

	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
	# left or right = translation and walking animation
		if is_on_floor():
			$AnimatedSprite.play("walk")

		if Input.is_action_pressed("ui_right"):
			x_direction = 1
			if $AnimatedSprite.is_flipped_h():
				$AnimatedSprite.set_flip_h(false)
		elif Input.is_action_pressed("ui_left"):
			x_direction = -1
			$AnimatedSprite.set_flip_h(true)

		velocity.x = CURRENT_SPEED * x_direction
	else:
	# down and no input = no movemnet
		if is_on_floor():
			if Input.is_action_pressed("ui_down"):
				toggle_duck(true)
			else:
				toggle_duck(false)
		velocity.x = 0


func check_health():
	if health < 1:
		alive = false
		print("Game Over!")


# toggle ducking animation
func toggle_duck(toggle):
	if toggle:
		$AnimatedSprite.play("duck")
		$StandingCollision.disabled = true
		$DuckingCollision.disabled = false
	else:
		$AnimatedSprite.play("idle")
		$StandingCollision.disabled = false
		$DuckingCollision.disabled = true


func bounce():
	set_modulate(Color(1.0,1.0,1.0,1.0))
	velocity.y = -JUMP_FORCE * .7


func on_hit_timer_timeout():
	hit(1)
	$AnimatedSprite.play("hit")
	hit_timer.stop()


func hit(amount):
	print("Health: ", health)
	set_modulate(Color(1.0, 0.2, 0.2, 0.3))
	health -= amount


func heal(amount):
	health += amount

extends KinematicBody2D

# x speed
export(int) var CURRENT_SPEED = 400
export(int) var MIN_SPEED = 400
export(int) var MAX_SPEED = 800
export(int) var SPEED_INC_RATE = 100

# y speed
export(int) var JUMP_FORCE = 400
export(int) var HIT_FORCE = JUMP_FORCE * 2
export(int) var GRAVITY = 10

# constants
const FLOOR = Vector2(0, -1)

# player velocity/direction
var velocity = Vector2.ZERO
var x_direction = 1
var hit_timer

# enemy
const ENEMY_LAYER = 4

# health
export var health = 5

func _ready():
	hit_timer = Timer.new()
	hit_timer.connect("timeout", self, "on_hit_timer_timeout")
	add_child(hit_timer)


func _physics_process(_delta):
	handle_input()
	handle_collisions()
	move_character()

# moves character
func move_character():
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)


# emit collided signals
func handle_collisions():
	for i in get_slide_count():
		var c = get_slide_collision(i)
		var layer = c.collider.get("collision_layer")

		if layer == ENEMY_LAYER:
			hit_timer.start()
			velocity.x = HIT_FORCE * x_direction
			health -= 1


func handle_input():
	# y-axis translation
	if Input.is_action_pressed("ui_up"):
		velocity.y = -JUMP_FORCE
	if Input.is_action_pressed("ui_down"):
		velocity.y = JUMP_FORCE
	if velocity.y < 0:
		$AnimatedSprite.play("jump")
	elif velocity.y > 0:
		$AnimatedSprite.play("fall")

	# x-axis and idle translation
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		left_or_right()
	else:
		stand_or_duck()


# movement functions

func left_or_right():
	if Input.is_key_pressed(KEY_SHIFT):
		if CURRENT_SPEED <= MAX_SPEED:
			CURRENT_SPEED += SPEED_INC_RATE
			$AnimatedSprite.set_speed_scale(2)
	else:
		if CURRENT_SPEED >= MIN_SPEED:
			CURRENT_SPEED -= SPEED_INC_RATE
			$AnimatedSprite.set_speed_scale(1)

	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
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

# handle ducking
func stand_or_duck():
	if is_on_floor():
		if Input.is_action_pressed("ui_down"):
			toggle_duck(true)
		else:
			toggle_duck(false)
	velocity.x = 0


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


func on_hit_timer_timeout():
	pass

func hit(amount):
	health -= amount

func heal(amount):
	health += amount

extends Area2D

var laserPaths = {
	"blue": {
		"burst": "res://assets/items/lasers/laserBlueBurst.png",
		"beam": "res://assets/items/lasers/laserBlueHorizontal.png",
	},
	"green": {
		"burst": "res://assets/items/lasers/laserGreenBurst.png",
		"beam": "res://assets/items/lasers/laserGreenHorizontal.png",
	},
	"red": {
		"burst": "res://assets/items/lasers/laserRedBurst.png",
		"beam": "res://assets/items/lasers/laserRedHorizontal.png",
	},
	"yellow": {
		"burst": "res://assets/items/lasers/laserYellowBurst.png",
		"beam": "res://assets/items/lasers/laserYellowHorizontal.png",
	},
	"purple": {
		"burst": "res://assets/items/lasers/laserPurpleBurst.png",
		"beam": "res://assets/items/lasers/laserPurpleHorizontal.png",
	}
}

export(int) var projectile_speed = 1000
export(int) var direction = 1
export(String, "blue", "green", "red", "yellow", "purple") var laserColor
export(String, "burst", "beam") var laserType

var velocity = Vector2.ZERO

func _ready():
	var beam = get_lazer_sprite("blue", "beam")
	var burst = get_lazer_sprite("blue", "burst")
	add_child(beam)
	add_child(burst)


func get_random_color():
	var lazer_colors = laserPaths.keys()
	var rand_color = randi() % len(lazer_colors)

	return lazer_colors[rand_color]


func get_lazer_sprite(color, style):
	var image_path = laserPaths.get(color).get(style)
	var image_texture = load(image_path)

	var lazer_sprite = Sprite.new()
	lazer_sprite.set_texture(image_texture)
	lazer_sprite.name = color + style + "lazer"

	return lazer_sprite


func _physics_process(delta):
	velocity.x = projectile_speed * delta * direction
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

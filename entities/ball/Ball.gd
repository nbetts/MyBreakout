class_name Ball
extends KinematicBody2D

export var initial_speed = 500

var speed = initial_speed
var direction = Vector2()

#onready var paddleSound = $PaddleSound
#onready var wallSound = $WalSound
#onready var brickSound = $brickSound

func set_start_direction():
	direction = Vector2(rand_range(-0.2, 0.2), -1).normalized() * speed


func _physics_process(delta):
	var collision = move_and_collide(direction * delta)
	
	if collision:
		direction = direction.bounce(collision.normal)
		if collision.collider.is_in_group("paddle"):
			var x = direction.x + (collision.collider_velocity.x / 4)
			direction = Vector2(x, direction.y).normalized() * speed
		#	$SoundRacket.play()
		#else:
		#	$SoundWall.play()


func reset():
	var viewport = get_viewport_rect().size
	position = Vector2(viewport.x / 2, viewport.y / 2);
	set_start_direction()

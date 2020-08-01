class_name Ball
extends KinematicBody2D

export var initial_speed = 500

var speed = initial_speed
var direction = Vector2()
var damage = 1

#onready var paddleSound = $PaddleSound
#onready var wallSound = $WalSound
#onready var brickSound = $brickSound

func set_start_direction():
	direction = Vector2(rand_range(-0.5, 0.5), -1).normalized() * speed


func _physics_process(delta):
	var collision = move_and_collide(direction * delta)
	
	if collision:
		direction = direction.bounce(collision.normal)
		if collision.collider.is_in_group("paddle"):
			# Allow the paddle to give the ball some momentum
			var x = direction.x + (collision.collider_velocity.x / 2)
			# The nearer the edge of the paddle, the more sideways velocity
			x+= (position.x - collision.collider.position.x) * 5
			
			direction = Vector2(x, direction.y).normalized() * speed
		#	$SoundRacket.play()
		elif collision.collider.is_in_group("brick"):
			collision.collider.take_hit(damage)
		#else:
		#	$SoundWall.play()


func reset():
	var viewport = get_viewport_rect().size
	position = Vector2(viewport.x / 2, viewport.y / 2);
	set_start_direction()

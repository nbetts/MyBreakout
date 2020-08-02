class_name Ball
extends KinematicBody2D

export var initial_speed = 600

var speed = initial_speed
var direction = Vector2()
var damage = 1

onready var bounceSound = $BounceSound

func put_in_play(position: Vector2):
	self.position = position
	direction = Vector2(rand_range(-0.5, 0.5), -1).normalized() * speed


func _physics_process(delta):
	var collision = move_and_collide(direction * delta)
	
	if collision:
		direction = direction.bounce(collision.normal)

		if collision.collider.is_in_group("paddle"):
			# Allow the paddle to give the ball some momentum
			var x = direction.x + (collision.collider_velocity.x / 2)
			# The nearer the edge of the paddle, the more sideways velocity
			x+= (position.x - collision.collider.position.x) * 8
			
			# clamp the sideways velocity so that the ball doesn't take ages to travel
			x = clamp(x, -500, 500)
			
			direction = Vector2(x, direction.y).normalized() * speed
		elif collision.collider.is_in_group("brick"):
			collision.collider.take_hit(damage)
		
		bounceSound.play()

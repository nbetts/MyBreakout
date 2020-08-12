class_name Ball
extends KinematicBody2D

export var initial_speed = 600

enum state {
	MOVING,
	STUCK_TO_PADDLE
}

var current_state = state.STUCK_TO_PADDLE
var speed = initial_speed
var direction = Vector2()
var damage = 1
var paddle

onready var collisionShape = $CollisionShape2D
onready var bounceSound = $BounceSound

func _ready():
	paddle = get_node("../Paddle")


func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("left_click"):
		current_state = state.MOVING


func set_start_direction():
	direction = Vector2(rand_range(-0.5, 0.5), -1).normalized() * speed


func _physics_process(delta):
	match current_state:
		state.STUCK_TO_PADDLE:
			position = Vector2(paddle.position.x, paddle.position.y - collisionShape.shape.radius - 4)
		state.MOVING:
			var collision = move_and_collide(direction * delta)
			
			if collision:
				direction = direction.bounce(collision.normal)
				var x = direction.x
		
				if collision.collider.is_in_group("paddle"):
					# Allow the paddle to give the ball some momentum
					x += collision.collider_velocity.x / 2
					
					# The nearer the edge of the paddle, the more sideways velocity
					x+= (position.x - collision.collider.position.x) * 12
					
				elif collision.collider.is_in_group("brick"):
					collision.collider.take_hit(damage)
				
				# clamp the sideways velocity so that the ball doesn't take ages to travel
				x = clamp(x, -400, 400)
				direction = Vector2(x, direction.y).normalized() * speed
				bounceSound.play()

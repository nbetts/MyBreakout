class_name Paddle
extends KinematicBody2D

export var acceleration = 120
export var max_speed = 900
export var friction = 120

var velocity = Vector2.ZERO
var mouseDelta = 0

func _physics_process(_delta):
	move_using_mouse()


func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative.x
	

func move_using_mouse():
	move_and_collide(Vector2(mouseDelta, 0))
	mouseDelta = 0


func move_using_keyboard():
	# Update the X and Y velocity of the player based on which arrow keys are pressed
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if inputVector != Vector2.ZERO:
		# Apply an acceleration to the player movement, clamping the max speed
		velocity = velocity.move_toward(inputVector * max_speed, acceleration)
	else:
		# Slow down using friction when no keys are pressed
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	
	velocity = move_and_slide(velocity)

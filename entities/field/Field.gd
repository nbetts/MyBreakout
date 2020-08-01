class_name Field
extends Node2D

signal ball_fell_through_floor

const ball_scene = preload("res://entities/ball/Ball.tscn")
var ballsInPlay = 0

onready var paddle = $Paddle

func _ready():
	randomize()


func _input(event):
	if event.is_action_pressed("ui_down"):
		place_ball()


func _on_Floor_body_entered(body):
	if ballsInPlay > 1:
		ballsInPlay -= 1
	else:
		place_ball()


func place_ball():
	var ball = ball_scene.instance() as Ball
	add_child(ball)
	var ballPosition = Vector2(paddle.position.x, paddle.position.y - 12)
	ball.put_in_play(ballPosition)
	ballsInPlay += 1


func begin_game():
	paddle.position.x = get_viewport_rect().size.x / 2
	place_ball()
	# todo: place bricks

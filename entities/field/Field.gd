class_name Field
extends Node2D

signal ball_fell_through_floor

const ball_scene = preload("res://entities/ball/Ball.tscn")
var ball = null
var ballsInPlay = 0
var current_level = null
var max_level_score = 0
var player_score = 0

onready var paddle = $Paddle

func _ready():
	randomize()


func _input(event):
	# just for testing
	if event.is_action_pressed("ui_down"):
		place_ball()


func _on_Floor_body_entered(body):
	if ballsInPlay > 1:
		ballsInPlay -= 1
	else:
		place_ball()


func place_ball():
	ball = ball_scene.instance()
	add_child(ball)
	var ballPosition = Vector2(paddle.position.x, paddle.position.y - 15)
	ball.put_in_play(ballPosition)
	ballsInPlay += 1


func begin_game(level):
	player_score = 0
	var current_level_scene = load("res://levels/Level1.tscn")
	
	if current_level != null:
		remove_child(current_level)

	current_level = current_level_scene.instance()
	add_child(current_level)
	
	
	paddle.position.x = get_viewport_rect().size.x / 2
	place_ball()
	# todo: place bricks

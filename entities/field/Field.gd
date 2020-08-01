extends Node2D

signal ball_fell_through_floor

const ball_scene = preload("res://entities/ball/Ball.tscn")

var ball: Ball

func _ready():
	place_ball()


func _on_Floor_body_entered(body):
	emit_signal("ball_fell_through_floor")


func place_ball():
	ball = ball_scene.instance() as Ball
	add_child(ball)
	ball.reset()

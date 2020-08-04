class_name Field
extends Node2D

signal game_over

const ball_scene = preload("res://entities/ball/Ball.tscn")
var ball = null
var current_level = null

var player_lives = 0
var player_score = 0
var ballsInPlay = 0
var max_level_score = 0

onready var paddle = $Paddle
onready var livesIndicator = $HUD/LivesIndicator
onready var scoreLabel = $HUD/ScoreLabel

func _ready():
	randomize()
	


func _input(event):
	# just for testing
	if event.is_action_pressed("ui_down"):
		place_ball()


func _on_Floor_body_entered(body):
	update_lives(player_lives - 1)
	ballsInPlay -= 1

	if ballsInPlay <= 0:
		place_ball()


func place_ball():
	ball = ball_scene.instance()
	call_deferred("add_child", ball)
	var ballPosition = Vector2(paddle.position.x, paddle.position.y - 15)
	ball.put_in_play(ballPosition)
	ballsInPlay += 1


func begin_game(level):
	var current_level_scene = load("res://levels/Level%d.tscn" % level)
	
	if current_level != null:
		remove_child(current_level)

	current_level = current_level_scene.instance() as Level
	current_level.connect("damageTaken", self, "add_to_score")
	add_child(current_level)
	
	paddle.position.x = get_viewport_rect().size.x / 2
	place_ball()
	update_lives(3)
	update_score(0)


func update_lives(lives):
	player_lives = lives
	livesIndicator.rect_size.x = lives * 40
	
	if (lives <= 0):
		emit_signal("game_over")


func add_to_score(points):
	update_score(player_score + points)


func update_score(score):
	player_score = score
	scoreLabel.text = 'Score   ' + str(score)
	

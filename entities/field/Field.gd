class_name Field
extends Node2D

signal game_won
signal game_over

const ball_scene = preload("res://entities/ball/Ball.tscn")


var current_level = null
var is_playing = false
var player_lives = 0
var player_score = 0
var ballsInPlay = 0

onready var paddle = $Paddle
onready var livesIndicator = $CanvasLayer/HUD/LivesIndicator
onready var scoreLabel = $CanvasLayer/HUD/ScoreLabel


func _on_Floor_body_entered(_body):
	ballsInPlay -= 1
	
	if (ballsInPlay <= 0):
		update_lives(player_lives - 1)
		if (player_lives <= 0):
			emit_signal("game_over")
		else:
			add_ball_to_field()


func add_ball_to_field():
	var ball = ball_scene.instance()
	call_deferred("add_child", ball)
	ball.set_start_direction()
	ballsInPlay += 1


func begin_game(level):
	# Load level
	var current_level_scene = load("res://levels/Level%d.tscn" % level)
	
	if current_level != null:
		remove_child(current_level)

	current_level = current_level_scene.instance() as Level
	current_level.connect("brick_damaged", self, "brick_damaged")
	current_level.connect("brick_died", self, "brick_died")
	current_level.connect("all_bricks_died", self, "all_bricks_died")
	add_child(current_level)
	
	# Reset paddle position
	paddle.position.x = get_viewport_rect().size.x / 2
	
	# Reset level variables
	ballsInPlay = 0
	add_ball_to_field()
	update_lives(3)
	update_score(0)
	is_playing = true


func end_game():
	is_playing = false
	current_level.queue_free()
	

func update_lives(lives):
	player_lives = lives
	livesIndicator.rect_size.x = lives * 40
	
	if (lives > 0):
		livesIndicator.show()
	else:
		livesIndicator.hide()


func brick_damaged(damage):
	# increase player score by the damage done to the brick
	add_to_score(damage)


func brick_died():
	# add small bonus to score when a brick has died
	add_to_score(3)


func all_bricks_died():
	emit_signal("game_won")


func add_to_score(points):
	update_score(player_score + points)


func update_score(score):
	player_score = score
	scoreLabel.text = 'Score   ' + str(score)
	

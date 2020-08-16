class_name Field
extends Node2D

signal game_won
signal game_over

const ball_scene = preload("res://entities/ball/Ball.tscn")


var current_level = null
var player_lives = 0
var player_score = 0
var ballsInPlay = 0

onready var level_timer = $LevelTimer
onready var paddle = $Paddle
onready var lives_indicator = $CanvasLayer/HUD/LivesIndicator
onready var score_indicator = $CanvasLayer/HUD/GridContainer/ScoreIndicator
onready var time_indicator = $CanvasLayer/HUD/GridContainer/TimeIndicator

func _on_Floor_body_entered(_body):
	ballsInPlay -= 1
	
	if (ballsInPlay <= 0):
		update_lives(player_lives - 1)
		if (player_lives <= 0):
			end_game(false)
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
	current_level.connect("timed_out", self, "timed_out")
	add_child(current_level)
	
	# Reset paddle position
	paddle.position.x = get_viewport_rect().size.x / 2
	
	# Reset ball
	ballsInPlay = 0
	add_ball_to_field()
	
	# Reset UI indicators
	update_lives(3)
	update_score_indicator(0)
	update_time_indicator(current_level.time_remaining)
	
	# Begin level timer
	level_timer.start()
	

func end_game(won):
	level_timer.stop()
	if won:
		emit_signal("game_won")
	else:
		emit_signal("game_over")


func unmount_level():
	level_timer.stop()
	current_level.queue_free()


func brick_damaged(damage):
	# increase player score by the damage done to the brick
	add_to_score(damage)


func brick_died():
	# add small bonus to score when a brick has died
	add_to_score(3)


func all_bricks_died():
	end_game(true)


func timed_out():
	end_game(false)
	

func update_lives(lives):
	player_lives = lives
	update_lives_indicator(lives)


func update_lives_indicator(lives):
	if (lives > 0):
		lives_indicator.show()
	else:
		lives_indicator.hide()

	print('lives_indicator.rect_size.x a ', lives_indicator.rect_size.x)
	lives_indicator.rect_size.x = lives * 40
	print('lives_indicator.rect_size.x b ', lives_indicator.rect_size.x)


func add_to_score(points):
	update_score_indicator(player_score + points)


func update_score_indicator(score):
	player_score = score
	score_indicator.text = str(score)


func update_time_indicator(time: int):
	var minutes: int = time / 60
	var seconds: int = time % 60
	time_indicator.text = "%d:%02d" % [minutes, seconds]


func _on_LevelTimer_timeout():
	current_level.update_time_remaining(current_level.time_remaining - level_timer.wait_time)
	update_time_indicator(current_level.time_remaining)

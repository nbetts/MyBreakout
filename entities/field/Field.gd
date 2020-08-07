class_name Field
extends Node2D

signal game_won
signal game_over

const ball_scene = preload("res://entities/ball/Ball.tscn")
var current_level = null

var player_lives = 0
var player_score = 0
var ballsInPlay = 0

onready var paddle = $Paddle
onready var livesIndicator = $CanvasLayer/HUD/LivesIndicator
onready var scoreLabel = $CanvasLayer/HUD/ScoreLabel

func _ready():
	randomize()
	


func _input(event):
	# just for testing
	if event.is_action_pressed("ui_down"):
		place_ball()


func _on_Floor_body_entered(_body):
	ballsInPlay -= 1
	
	if (ballsInPlay <= 0):
		update_lives(player_lives - 1)
		if (player_lives <= 0):
			emit_signal("game_over")
		else:
			place_ball()


func place_ball():
	var ball = ball_scene.instance()
	call_deferred("add_child", ball)
	var ballRadius = ball.get_node("CollisionShape2D").shape.radius
	print('ballRadius', ballRadius)
	var ballPosition = Vector2(paddle.position.x, paddle.position.y - ballRadius - 4)
	ball.put_in_play(ballPosition)
	ballsInPlay += 1


func begin_game(level):
	# Load level
	var current_level_scene = load("res://levels/Level%d.tscn" % level)
	
	if current_level != null:
		remove_child(current_level)

	current_level = current_level_scene.instance() as Level
	current_level.connect("damageTaken", self, "add_to_score")
	add_child(current_level)
	
	# Reset paddle position
	paddle.position.x = get_viewport_rect().size.x / 2
	
	# Reset level variables
	ballsInPlay = 0
	place_ball()
	update_lives(3)
	update_score(0)


func update_lives(lives):
	player_lives = lives
	livesIndicator.rect_size.x = lives * 40


func add_to_score(points):
	update_score(player_score + points)
	
	if player_score >= current_level.max_level_score:
		emit_signal("game_won")


func update_score(score):
	player_score = score
	scoreLabel.text = 'Score   ' + str(score)
	

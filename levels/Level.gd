class_name Level
extends Node2D

signal brick_damaged(damage)
signal brick_died
signal all_bricks_died

var brick_count = 0
var bricks_remaining = 0

func _ready():
	for child in get_children():
		child.connect("damaged", self, "brick_damaged")
		child.connect("died", self, "brick_died")
		brick_count += 1
	
	bricks_remaining = brick_count


func brick_damaged(damage):
	emit_signal("brick_damaged", damage)


func brick_died():
	bricks_remaining -= 1
	emit_signal("brick_died")
	
	if bricks_remaining <= 0:
		emit_signal("all_bricks_died")

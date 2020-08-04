class_name Level
extends Node2D

signal damageTaken(damage)

export var max_level_score = 0

func _ready():
	for child in get_children():
		child.connect("damageTaken", self, "emit_damage")
		max_level_score += child.health


func emit_damage(damage):
	emit_signal("damageTaken", damage)

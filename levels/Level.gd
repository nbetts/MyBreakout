class_name Level
extends Node2D

signal damageTaken(damage)

func _ready():
	var children = get_children()
	for child in children:
		child.connect("damageTaken", self, "emit_damage")


func emit_damage(damage):
	emit_signal("damageTaken", damage)

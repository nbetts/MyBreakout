class_name Brick
extends StaticBody2D

signal damageTaken(damage)

export var health = 5

onready var polygon = $Polygon2D

func _ready():
	update_color()


func update_color():
	match health:
		1: polygon.color = '#c30834'
		2: polygon.color = '#ed760c'
		3: polygon.color = '#f7ff00'
		4: polygon.color = '#37e207'
		5: polygon.color = '#38f7dc'
		6: polygon.color = '#1567f4'
		7: polygon.color = '#5d0ee9'
		8: polygon.color = '#e00fd3'
		_: polygon.color = '#000000'


func take_hit(damage):
	var damageTaken = min(damage, health)
	health -= damageTaken
	emit_signal("damageTaken", damageTaken)

	if health > 0:
		update_color()
	else:
		queue_free()

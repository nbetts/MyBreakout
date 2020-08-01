extends Area2D

signal died

export var health = 5

onready var polygon = $Polygon2D

func _ready():
	update_color()


func update_color():
	match health:
		8: polygon.color = '#51ee8b'
		7: polygon.color = '#e551ee'
		6: polygon.color = '#cfee51'
		5: polygon.color = '#ee5c51'
		4: polygon.color = '#51dfee'
		3: polygon.color = '#7b51ee'
		2: polygon.color = '#eead51'
		1: polygon.color = '#51ee66'
		_: polygon.color = '#000000'


func _on_Brick_body_entered(body):
	health -= 1
	if health > 0:
		update_color()
	else:
		emit_signal("died")
		queue_free()

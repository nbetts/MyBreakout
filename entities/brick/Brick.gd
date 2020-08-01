class_name Brick
extends StaticBody2D

signal tookHit
signal died

export var health = 5

onready var polygon = $Polygon2D

func _ready():
	update_color()


func update_color():
	match health:
		7: polygon.color = '#7b51ee'
		6: polygon.color = '#e551ee'
		5: polygon.color = '#ee5c51'
		4: polygon.color = '#eead51'
		3: polygon.color = '#cfee51'
		2: polygon.color = '#51ee8b'
		1: polygon.color = '#51dfee'
		_: polygon.color = '#000000'


func take_hit(damage):
	health -= damage
	if health > 0:
		update_color()
		emit_signal("tookHit")
	else:
		queue_free()
		emit_signal("died")

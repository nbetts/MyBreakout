extends GridContainer

signal level_button_pressed(level)

# Setup level signals.
func _ready():
	var level_file_regex = RegEx.new()
	level_file_regex.compile("Level(?<level>[0-9]+)")
	var dir = Directory.new()
	dir.open("res://levels")
	dir.list_dir_begin()
	var file = dir.get_next()
	
	while file != "":
		var regex_result = level_file_regex.search(file.get_basename())
		if regex_result:
			var level = int(regex_result.get_string("level"))
			var level_button = Button.new()
			level_button.text = "%02d" % level
			level_button.connect("pressed", self, "level_button_press", [level])
			add_child(level_button)
		
		file = dir.get_next()


func level_button_press(level):
	emit_signal("level_button_pressed", level)

extends Area2D

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				print("Mouse click ", event.position)
				self.global_position = event.global_position

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	var bodies = get_overlapping_bodies()
	for bd in bodies:
		print(bd)
		if bd.has_method("set_selected"):
			bd.set_selected()
			return

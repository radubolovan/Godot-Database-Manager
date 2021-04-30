"""
class GDDBDataLabel
"""

class_name GDDBDataLabel

tool
extends Label

signal resize_property

var m_prop_id : int = gddb_constants.c_invalid_id
var m_prop_type : int = gddb_constants.c_invalid_id

var m_mouse_pos_pressed : Vector2 = Vector2()
var m_mouse_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_custom_minimum_size(Vector2(150.0, 24.0))

# called when the node gets an input
func _input(event : InputEvent) -> void :
	if(!gddb_globals.is_interface_active()):
		return

	var evLocal = $resize_ctrl.make_input_local(event)

	if event is InputEventMouseButton :
		if(event.button_index == BUTTON_LEFT):
			if(event.pressed):
				var rect = Rect2(Vector2(0, 0), $resize_ctrl.get_size())
				var inside = rect.has_point(evLocal.position)
				if(inside):
					m_mouse_pressed = true
					m_mouse_pos_pressed = evLocal.position
			else:
				m_mouse_pressed = false

	elif event is InputEventMouseMotion :
		if(m_mouse_pressed):
			var diff_x = evLocal.position.x - m_mouse_pos_pressed.x
			emit_signal("resize_property", m_prop_id, diff_x)

# sets property id
func set_prop_id(id : int) -> void:
	m_prop_id = id

# returns property id
func get_prop_id() -> int:
	return m_prop_id

# sets property type
func set_prop_type(prop_type : int) -> void :
	m_prop_type = prop_type

# returns property type
func get_prop_type() -> int :
	return m_prop_type

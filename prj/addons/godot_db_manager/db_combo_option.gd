"""
class GDDBComboBox
"""

class_name GDDBComboOption

tool
extends TextureButton

signal selected

var m_option_id : int = g_constants.c_invalid_id
var m_is_selected : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	$bullet_off.show()
	$bullet_on.hide()
	$normal.show()
	$hover.hide()

	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")

# sets the option id
func set_option_id(option_id : int) -> void :
	m_option_id = option_id

# returns option id
func get_option_id() -> int :
	return m_option_id

# sets the text
func set_text(text : String) -> void :
	$text.set_text(text)

# returns the text
func get_text() -> String :
	return $text.get_text()

# Called when the mouse enters the control’s Rect area
func on_mouse_entered() -> void:
	$normal.hide()
	$hover.show()

# Called when the mouse leaves the control’s Rect area
func on_mouse_exited() -> void:
	$normal.show()
	$hover.hide()

# Called when button is pressed
func on_pressed() -> void :
	# print("GDDBComboOption::on_pressed()")
	emit_signal("selected", m_option_id)

# set selected
func set_selected(select : bool) -> void :
	# print("GDDBComboOption::set_selected(" + str(select) + ")")
	m_is_selected = select
	update_interface()

# returns is if selected
func is_selected() -> bool :
	return m_is_selected

# updates interface
func update_interface():
	if(m_is_selected):
		$bullet_off.hide()
		$bullet_on.show()
	else:
		$bullet_off.show()
		$bullet_on.hide()

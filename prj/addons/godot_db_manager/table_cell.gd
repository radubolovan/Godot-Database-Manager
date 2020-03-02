"""
class GDDBTableCell
"""

class_name GDDBTableCell

tool
extends Control

signal edit_data
signal choose_resource

var m_prop_id : int = -1
var m_prop_type : int = g_constants.c_invalid_id
var m_row_idx : int = -1
var m_text : String = ""

func _ready() -> void :
	$LineEdit.connect("text_changed", self, "on_text_changed")
	$Button.connect("pressed", self, "on_button_pressed")

func _exit_tree() -> void :
	$LineEdit.disconnect("text_changed", self, "on_text_changed")

# sets the property id
func set_prop_id(id : int) -> void :
	m_prop_id = id

# returns the property id
func get_prop_id() -> int :
	return m_prop_id

# sets property type
func set_prop_type(data_type : int) -> void :
	# print("GDDBTableCell::set_prop_type(" + db_types.get_data_name(data_type) + ")")
	m_prop_type = data_type
	if(m_prop_type == db_types.e_prop_type_bool):
		$LineEdit.hide()
		$Button.hide()
		$CheckBox.show()
	elif(m_prop_type == db_types.e_prop_type_int):
		$LineEdit.show()
		$Button.hide()
		$CheckBox.hide()
	elif(m_prop_type == db_types.e_prop_type_float):
		$LineEdit.show()
		$Button.hide()
		$CheckBox.hide()
	elif(m_prop_type == db_types.e_prop_type_string):
		$LineEdit.show()
		$Button.hide()
		$CheckBox.hide()
	elif(m_prop_type == db_types.e_prop_type_resource):
		$LineEdit.hide()
		$Button.show()
		$CheckBox.hide()

func get_prop_type() -> int :
	return m_prop_type

# sets the row index
func set_row_idx(idx : int) -> void :
	m_row_idx = idx

# returns the property index
func get_row_idx() -> int :
	return m_row_idx

# sets the text
func set_text(text : String) -> void :
	m_text = text
	$LineEdit.set_text(text)
	$Button.set_text(text)
	$CheckBox.set_text(text)

# called when the button is pressed
func on_button_pressed():
	if(m_prop_type == db_types.e_prop_type_resource):
		emit_signal("choose_resource", m_prop_id, m_row_idx)

# called when edit the data
func on_text_changed(new_text : String) -> void :
	emit_signal("edit_data", m_prop_id, m_row_idx, new_text)

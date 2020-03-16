"""
class GDDBTableCell
"""

class_name GDDBTableCell

tool
extends Control

signal edit_data
signal choose_resource
signal choose_data

var m_prop_id : int = -1
var m_prop_type : int = g_constants.c_invalid_id
var m_row_idx : int = -1
var m_text : String = ""

func _ready() -> void :
	$LineEdit.connect("text_changed", self, "on_text_changed")
	$Button.connect("pressed", self, "on_button_pressed")

	$Button.set_clip_text(true)

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

	var data_type_changed = false

	if(m_prop_type != data_type):
		m_prop_type = data_type
		data_type_changed = true

	if(!data_type_changed):
		return

	if(m_prop_type == db_types.e_prop_type_bool):
		$LineEdit.hide()
		$Button.hide()
		$CheckBox.show()
		set_text("")
	elif(m_prop_type == db_types.e_prop_type_int):
		$LineEdit.show()
		$Button.hide()
		$CheckBox.hide()
		set_text("0")
	elif(m_prop_type == db_types.e_prop_type_float):
		$LineEdit.show()
		$Button.hide()
		$CheckBox.hide()
		set_text("0.0")
	elif(m_prop_type == db_types.e_prop_type_string):
		$LineEdit.show()
		$Button.hide()
		$CheckBox.hide()
		set_text("")
	elif(m_prop_type == db_types.e_prop_type_resource):
		$LineEdit.hide()
		$Button.show()
		$CheckBox.hide()
		set_text("res://")
	elif(m_prop_type >= db_types.e_data_types_count):
		$LineEdit.hide()
		$Button.show()
		$CheckBox.hide()
		set_text("{}")

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
	# print("GDDBTableCell::set_text(" + text + ")")
	m_text = text
	$LineEdit.set_text(m_text)
	$Button.set_text(m_text)
	$CheckBox.set_text(m_text)

# called when the button is pressed
func on_button_pressed() -> void:
	if(m_prop_type == db_types.e_prop_type_resource):
		# print("GDDBTableCell::on_button_pressed()")
		emit_signal("choose_resource", m_prop_id, m_row_idx)
	elif(m_prop_type >= db_types.e_data_types_count):
		emit_signal("choose_data", m_prop_id, m_row_idx, m_prop_type)

# called when edit the data
func on_text_changed(new_text : String) -> void :
	if(new_text.empty()):
		m_text = ""
		$LineEdit.set_text(m_text)
		$LineEdit.set_cursor_position(0)
		return

	if(m_prop_type == db_types.e_prop_type_int):
		if(!check_integer(new_text)):
			return

	if(m_prop_type == db_types.e_prop_type_float):
		if(!check_float(new_text)):
			return

	emit_signal("edit_data", m_prop_id, m_row_idx, new_text)

# checks if the text is integer
func check_integer(text : String) -> bool :
	if(text.is_valid_integer()):
		if(text.begins_with("0")):
			m_text = "0"
			$LineEdit.set_text(m_text)
			$LineEdit.set_cursor_position(1)
			return true

		m_text = text
		return true

	$LineEdit.set_text(m_text)
	$LineEdit.set_cursor_position(m_text.length())
	return false

func check_float(text : String) -> bool:
	if(text.is_valid_float()):
		if(text.begins_with("00") || text.begins_with("01") || text.begins_with("02")
			 || text.begins_with("03") || text.begins_with("04") || text.begins_with("05")
			 || text.begins_with("06") || text.begins_with("07") || text.begins_with("08")
			 || text.begins_with("09")):
			m_text = "0"
			$LineEdit.set_text(m_text)
			$LineEdit.set_cursor_position(1)
			return true

		m_text = text
		return true

	$LineEdit.set_text(m_text)
	$LineEdit.set_cursor_position(m_text.length())
	return false

"""
class GDDBTableCell
"""

class_name GDDBTableCell

tool
extends Control

signal edit_data
signal choose_resource
signal choose_data
signal edit_string

const c_cell_min_width = 150

var m_prop_id : int = -1
var m_prop_type : int = gddb_constants.c_invalid_id
var m_row_idx : int = -1
var m_text : String = ""

func _ready() -> void :
	$LineEdit.connect("text_changed", self, "on_text_changed")
	$LineEdit/edit_btn.connect("pressed", self, "on_edit_string")

	$Button.connect("pressed", self, "on_button_pressed")
	$Button.set_clip_text(true)

	$CheckBox.connect("toggled", self, "on_toggle_button")

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
	# print("GDDBTableCell::set_prop_type(" + str(data_type) + ")")

	var data_type_changed = false

	if(m_prop_type != data_type):
		m_prop_type = data_type
		data_type_changed = true

	if(!data_type_changed):
		return

	if(m_prop_type == gddb_types.e_prop_type_bool):
		$LineEdit.hide()
		$Button.hide()
		$CheckBox.show()
		set_text("")
	elif(m_prop_type == gddb_types.e_prop_type_int):
		$LineEdit.show()
		$LineEdit/edit_btn.hide()
		$Button.hide()
		$CheckBox.hide()
		set_text("0")
	elif(m_prop_type == gddb_types.e_prop_type_float):
		$LineEdit.show()
		$LineEdit/edit_btn.hide()
		$Button.hide()
		$CheckBox.hide()
		set_text("0.0")
	elif(m_prop_type == gddb_types.e_prop_type_string):
		$LineEdit.show()
		$LineEdit/edit_btn.show()
		$Button.hide()
		$CheckBox.hide()
		set_text("")
	elif(m_prop_type == gddb_types.e_prop_type_resource):
		$LineEdit.hide()
		$Button.show()
		$CheckBox.hide()
		set_text("res://")
	elif(m_prop_type >= gddb_types.e_prop_types_count):
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
	if(m_prop_type == gddb_types.e_prop_type_bool):
		$CheckBox.set_pressed((text == "1"))

# sets autoincrement
func enable_autoincrement(enable : bool) -> void :
	$LineEdit.set_editable(!enable)

# refreshes the width by the property name
func refresh_width(prop_name : String) -> void :
	var size = get_custom_minimum_size()
	size.x = max(c_cell_min_width, get_font("normal_font").get_string_size(prop_name).x + 10)
	set_custom_minimum_size(size)

# called when the checkbox is toggled/untoggled
func on_toggle_button(enable : bool) -> void :
	var data = "0"
	if(enable):
		data = "1"
	emit_signal("edit_data", m_prop_id, m_row_idx, data)

# called when the button is pressed
func on_button_pressed() -> void :
	if(m_prop_type == gddb_types.e_prop_type_resource):
		# print("GDDBTableCell::on_button_pressed()")
		emit_signal("choose_resource", m_prop_id, m_row_idx)
	elif(m_prop_type >= gddb_types.e_prop_types_count):
		emit_signal("choose_data", m_prop_id, m_row_idx, m_prop_type)

# called when the edit string button is pressed
func on_edit_string() -> void :
	emit_signal("edit_string", m_prop_id, m_row_idx, m_text)

# called when edit the data
func on_text_changed(new_text : String) -> void :
	if(new_text.empty()):
		m_text = ""
		$LineEdit.set_text(m_text)
		$LineEdit.set_cursor_position(0)
		return

	if(m_prop_type == gddb_types.e_prop_type_int):
		if(!check_integer(new_text)):
			return

	if(m_prop_type == gddb_types.e_prop_type_float):
		if(!check_float(new_text)):
			return

	emit_signal("edit_data", m_prop_id, m_row_idx, new_text)

# checks if the text is integer
func check_integer(text : String) -> bool :
	var is_negative = false

	# check if the string is probably a number, but starts with "-"
	if(text.begins_with("-")):
		text.erase(0, 1)
		is_negative = true

	# check if the current string is only "-"
	if(text.empty()):
		m_text = "-"
		$LineEdit.set_text(m_text)
		$LineEdit.set_cursor_position(m_text.length())
		return true

	if(text.is_valid_integer()):
		if(text.begins_with("0")):
			# a negative integer cannot start with "0"
			if(is_negative):
				m_text = "-"
				$LineEdit.set_text(m_text)
				$LineEdit.set_cursor_position(1)
				return true

			# a positive number starting with "0" can be only "0"
			m_text = "0"
			$LineEdit.set_text(m_text)
			$LineEdit.set_cursor_position(1)
			return true

		# don't add more "-" in front of the number
		if(text.begins_with("-")):
			text.erase(0, 1)

		# add back the "-"
		if(is_negative):
			m_text = "-" + text
		else:
			m_text = text

		$LineEdit.set_text(m_text)
		$LineEdit.set_cursor_position(m_text.length())
		return true

	$LineEdit.set_text(m_text)
	$LineEdit.set_cursor_position(m_text.length())
	return false

func check_float(text : String) -> bool :
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

"""
class GDDBEditStringDlg
"""

class_name GDDBEditStringDlg

tool
extends WindowDialog

signal string_edited

var m_prop_id = gddb_constants.c_invalid_id
var m_row_idx = gddb_constants.c_invalid_id
var m_data_text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$v_layout/btns/ok_btn.connect("pressed", self, "on_ok_btn_pressed")
	$v_layout/btns/cancel_btn.connect("pressed", self, "on_cancel_btn_pressed")

	$v_layout/text.connect("text_changed", self, "on_text_changed")

# sets property id
func set_prop_id(prop_id : int) -> void:
	m_prop_id = prop_id

# returns property id
func get_prop_id() -> int :
	return m_prop_id

# sets row index
func set_row_idx(row_idx : int) -> void :
	m_row_idx = row_idx

# returns row index
func get_row_idx() -> int :
	return m_row_idx

# sets data text
func set_data_text(text : String) -> void :
	m_data_text = text
	$v_layout/text.set_text(text)

# returns data text
func get_data_text() -> String :
	return m_data_text

# Called when the OK button is pressed
func on_ok_btn_pressed() -> void :
	emit_signal("string_edited")
	hide()

# Called when the Cancel button is pressed
func on_cancel_btn_pressed() -> void :
	hide()

# Called when text is changed
func on_text_changed() -> void:
	m_data_text = $v_layout/text.get_text()

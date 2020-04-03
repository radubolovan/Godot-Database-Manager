"""
class GDDBDeletePropDlg
"""

class_name GDDBDeletePropDlg

tool
extends WindowDialog

signal delete_prop

var m_prop_id = gddb_constants.c_invalid_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	$v_layout/buttons/ok_btn.connect("pressed", self, "on_ok_btn_pressed")
	$v_layout/buttons/cancel_btn.connect("pressed", self, "on_cancel_btn_pressed")

# sets the property id
func set_prop_id(prop_id : int) -> void :
	m_prop_id = prop_id

# returns the property id
func get_prop_id() -> int :
	return m_prop_id

func set_prop_name(prop_name : String) -> void:
	var text = "Delete property with name \"" + prop_name + "\" ?"
	$v_layout/prop_info/prop_lbl.set_text(text)

# returns the table id
func get_table_id() -> int :
	return m_prop_id

# called when the OK button is pressed
func on_ok_btn_pressed() -> void :
	emit_signal("delete_prop")
	hide()

func on_cancel_btn_pressed() -> void:
	hide()

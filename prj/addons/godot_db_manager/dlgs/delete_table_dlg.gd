"""
class GDDBDeleteTableDlg
"""

class_name GDDBDeleteTableDlg

tool
extends WindowDialog

signal delete_table

var m_table_id = g_constants.c_invalid_id

# Called when the node enters the scene tree for the first time.
func _ready():
	$v_layout/buttons/ok_btn.connect("pressed", self, "on_ok_btn_pressed")

# sets the table id
func set_table_id(table_id : int) -> void:
	m_table_id = table_id

func set_table_name(table_name : String) -> void:
	var text = "Delete table with name \"" + table_name + "\" ?"

# returns the table id
func get_table_id() -> int:
	return m_table_id

# called when the OK button is pressed
func on_ok_btn_pressed() -> void:
	emit_signal("delete_table")
	hide()

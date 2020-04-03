"""
class GDDBDeleteTableDlg
"""

class_name GDDBDeleteTableDlg

tool
extends WindowDialog

signal delete_table

var m_table_id = gddb_constants.c_invalid_id

# Called when the node enters the scene tree for the first time.
func _ready():
	$v_layout/buttons/ok_btn.connect("pressed", self, "on_ok_btn_pressed")
	$v_layout/buttons/cancel_btn.connect("pressed", self, "on_cancel_btn_pressed")

# sets the table id
func set_table_id(table_id : int) -> void:
	m_table_id = table_id

func set_table_name(table_name : String) -> void:
	var text = "Delete table with name \"" + table_name + "\" ?"
	$v_layout/table_info/table_lbl.set_text(text)

# returns the table id
func get_table_id() -> int:
	return m_table_id

# called when the OK button is pressed
func on_ok_btn_pressed() -> void:
	emit_signal("delete_table")
	hide()

func on_cancel_btn_pressed() -> void:
	hide()

"""
class GDDBNewDBDlg
"""

class_name GDDBNewTableDlg

tool
extends WindowDialog

signal create_new_table

var m_table_id = gddb_constants.c_invalid_id
var m_current_table_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$v_layout/buttons/ok_btn.connect("pressed", self, "on_ok_btn_pressed")
	$v_layout/buttons/cancel_btn.connect("pressed", self, "on_cancel_btn_pressed")
	$v_layout/table_info/table_edt.connect("text_changed", self, "on_text_changed")
	$v_layout/table_info/table_edt.connect("text_entered", self, "on_text_confirmed")
	m_current_table_name = ""

# sets the table id
func set_table_id(table_id : int) -> void:
	m_table_id = table_id

# returns the table id
func get_table_id() -> int:
	return m_table_id

# sets the table name
func set_init_name(table_name : String) -> void:
	# print("cNewTableDlg::set_init_name(" + name + ")")
	m_current_table_name = table_name
	$v_layout/table_info/table_edt.set_text(m_current_table_name)

func on_text_changed(new_text: String) -> void:
	var change_text = true
	if(!gddb_globals.check_db_name(new_text)):
		change_text = false
	else:
		if(new_text.length() > gddb_constants.c_max_db_name_len):
			change_text = false
		else:
			change_text = true

	if(change_text):
		m_current_table_name = $v_layout/table_info/table_edt.get_text()
	else:
		$v_layout/table_info/table_edt.set_text(m_current_table_name)
		$v_layout/table_info/table_edt.set_cursor_position(m_current_table_name.length())

# called when the user presses the ENTER key
func on_text_confirmed(text : String) -> void:
	if(m_current_table_name.empty()):
		return
	handle_table_name()
	hide()

# called when the OK button is pressed
func on_ok_btn_pressed() -> void:
	if(!m_current_table_name.empty()):
		handle_table_name()
		hide()

# called when the Cancel button is pressed
func on_cancel_btn_pressed() -> void :
	hide()

# handles the text in the EditLine
func handle_table_name() -> void:
	emit_signal("create_new_table", m_current_table_name)

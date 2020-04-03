"""
class GDDBNewDBDlg
"""

class_name GDDBNewDBDlg

tool
extends WindowDialog

signal create_new_db

var m_current_db_name = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	$v_layout/buttons/ok_btn.connect("pressed", self, "on_ok_btn_pressed")
	$v_layout/buttons/cancel_btn.connect("pressed", self, "on_cancel_btn_pressed")
	connect("about_to_show", self, "on_about_to_show")
	$v_layout/db_info/db_edt.connect("text_changed", self, "on_text_changed")
	$v_layout/db_info/db_edt.connect("text_entered", self, "on_text_confirmed")

# Called when the node is about to be shown.
func on_about_to_show() -> void :
	m_current_db_name = ""
	$v_layout/db_info/db_edt.set_text(m_current_db_name)

# called everytime the text is changed
func on_text_changed(new_text: String) -> void :
	var change_text = true
	if(!gddb_globals.check_db_name(new_text)):
		change_text = false
	else:
		if(new_text.length() > gddb_constants.c_max_db_name_len):
			change_text = false
		else:
			change_text = true

	if(change_text):
		m_current_db_name = $v_layout/db_info/db_edt.get_text()
	else:
		$v_layout/db_info/db_edt.set_text(m_current_db_name)
		$v_layout/db_info/db_edt.set_cursor_position(m_current_db_name.length())

# called when the user presses the ENTER key
func on_text_confirmed(text : String) -> void :
	# print("GDDBNewDBDlg::on_text_confirmed(" + text + ")")
	if(m_current_db_name.empty()):
		return
	handle_db_name()
	hide()

# called when the OK button is pressed
func on_ok_btn_pressed() -> void :
	if(!m_current_db_name.empty()):
		handle_db_name()

# called when the Cancel button is pressed
func on_cancel_btn_pressed() -> void :
	hide()

# handles the name of the database
func handle_db_name() -> void :
	emit_signal("create_new_db", m_current_db_name)

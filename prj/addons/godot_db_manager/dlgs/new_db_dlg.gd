tool
extends AcceptDialog

signal create_new_db

var m_current_db_name = ""

func _ready():
	connect("confirmed", self, "on_ok_btn_pressed")
	connect("about_to_show", self, "on_about_to_show")
	$db_info/db_edt.connect("text_changed", self, "on_text_changed")
	$db_info/db_edt.connect("text_entered", self, "on_text_confirmed")

func on_about_to_show():
	m_current_db_name = ""
	$db_info/db_edt.set_text(m_current_db_name)

func on_text_changed(new_text: String) -> void:
	if(!g_constants.check_db_name(new_text)):
		$db_info/db_edt.set_text(m_current_db_name)
		$db_info/db_edt.set_cursor_position(m_current_db_name.length())
	else:
		m_current_db_name = $db_info/db_edt.get_text()

func on_text_confirmed(text):
	handle_db_name()
	hide()

func on_ok_btn_pressed():
	handle_db_name()

func handle_db_name():
	var text = $db_info/db_edt.get_text()
	if(text == ""):
		return
	emit_signal("create_new_db", text)

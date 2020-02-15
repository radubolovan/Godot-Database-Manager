tool
extends AcceptDialog

signal create_new_db

func _ready():
	connect("confirmed", self, "on_ok_btn_pressed")
	$db_info/db_edt.connect("text_entered", self, "on_text_confirmed")

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

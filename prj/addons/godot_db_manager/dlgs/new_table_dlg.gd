tool
extends AcceptDialog

signal create_new_table

func _ready():
	connect("confirmed", self, "on_ok_btn_pressed")
	$table_info/table_edt.connect("text_entered", self, "on_text_confirmed")

func on_text_confirmed(text):
	handle_table_name()
	hide()

func on_ok_btn_pressed():
	handle_table_name()

func handle_table_name():
	var text = $table_info/table_edt.get_text()
	if(text == ""):
		return
	emit_signal("create_new_table", text)

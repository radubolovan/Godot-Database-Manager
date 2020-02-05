extends AcceptDialog

signal create_new_column

func _ready():
	connect("confirmed", self, "on_ok_btn_pressed")

func refresh():
	$column_info/column_name_edt.set_text("")
	$column_info/column_type_opt.add_item("Int")
	$column_info/column_type_opt.add_item("String")

func on_ok_btn_pressed():
	var column_type = $column_info/column_type_opt.get_selected_id()
	var text = $column_info/column_name_edt.get_text()
	if(text == ""):
		return
	emit_signal("create_new_column", column_type, text)

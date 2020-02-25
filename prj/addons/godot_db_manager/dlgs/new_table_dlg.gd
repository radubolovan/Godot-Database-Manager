tool
extends WindowDialog

signal create_new_table

var m_table_id = g_constants.c_invalid_id

# Called when the node enters the scene tree for the first time.
func _ready():
	$v_layout/buttons/ok_btn.connect("pressed", self, "on_ok_btn_pressed")
	$v_layout/table_info/table_edt.connect("text_entered", self, "on_text_confirmed")

# sets the table id
func set_table_id(table_id : int) -> void:
	m_table_id = table_id

# returns the table id
func get_table_id() -> int:
	return m_table_id

# sets the table name
func set_init_name(table_name : String) -> void:
	# print("cNewTableDlg::set_init_name(" + name + ")")
	$v_layout/table_info/table_edt.set_text(table_name)

# called when the user presses the ENTER key
func on_text_confirmed(text : String) -> void:
	handle_table_name()
	hide()

# called when the OK button is pressed
func on_ok_btn_pressed() -> void:
	handle_table_name()

# handles the text in the EditLine
func handle_table_name() -> void:
	var text = $v_layout/table_info/table_edt.get_text()
	if(text == ""):
		return
	emit_signal("create_new_table", text)

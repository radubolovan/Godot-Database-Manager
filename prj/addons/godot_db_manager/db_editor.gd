tool
extends Tabs

var m_name = ""
var m_database = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_tab_align(Tabs.ALIGN_LEFT)
	set_tab_close_display_policy(Tabs.CLOSE_BUTTON_SHOW_ALWAYS)

	$main_window/tables_panel/tables_list.connect("add_table", self, "on_add_table")
	$main_window/tables_panel/tables_list.connect("edit_table_name", self, "on_edit_table")
	$main_window/tables_panel/tables_list.connect("delete_table", self, "on_delete_table")

	$new_table_dlg.connect("create_new_table", self, "on_create_table")

	$error_dlg.connect("confirmed", self, "on_retry_create_table")

# overrides the member from base class
func set_name(ctrl_name) -> void:
	m_name = ctrl_name
	.set_name(ctrl_name)

# sets the database; for easy access
func set_database(db) -> void:
	m_database = db
	$main_window/tables_panel/table.hide()

# sets the database to be dirty; should be saved
func set_dirty(dirty) -> void:
	if(dirty):
		var title = m_name + "*"
		.set_name(title)
	else:
		.set_name(m_name)

# called when the user presses the "add_table" button from the "tables_list/tables_header"
func on_add_table() -> void:
	$new_table_dlg.set_init_name("")
	$new_table_dlg.popup_centered()

# called when the user accepts the name of the table in the "new_table_dlg"
func on_create_table(table_name : String) -> void:
	var table = m_database.add_table(table_name)
	if(null == table):
		$error_dlg.set_text("Table with the name \"" + table_name + "\" already exists" )
		$error_dlg.popup_centered()
		return
	$main_window/tables_panel/tables_list.create_table(table)
	$main_window/tables_panel/table.show()

# called when the user retryes to create a table (changed the name)
func on_retry_create_table() -> void:
	$new_table_dlg.set_init_name("")
	$new_table_dlg.popup_centered()

# called when the user presses the "edit_table_name" from the "tables/list/table"
func on_edit_table(table_id : int, table_name : String) -> void:
	print("cDbEditor::on_edit_table(" + str(table_id) + ", " + table_name + ")")
	$new_table_dlg.disconnect("create_new_table", self, "on_create_table")
	$new_table_dlg.connect("create_new_table", self, "on_table_name_edited")
	$new_table_dlg.set_table_id(table_id)
	$new_table_dlg.set_init_name(table_name)
	$new_table_dlg.popup_centered()

# called when the user presses the "delete_table" from the "tables/list/table"
func on_delete_table(table_id : int) -> void:
	print("cDbEditor::on_delete_table(" + str(table_id) + ")")
	$delete_table_dlg.connect("delete_table", self, "on_delete_table_accepted")
	$delete_table_dlg.set_table_id(table_id)
	$delete_table_dlg.popup_centered()

# called when the user accepts the name of the table in the "new_table_dlg"
func on_table_name_edited(table_name : String) -> void:
	var table_id = $new_table_dlg.get_table_id()
	if(!m_database.edit_table_name(table_name, table_id)):
		$error_dlg.set_text("Table with the name \"" + table_name + "\" already exists" )
		$error_dlg.popup_centered()
		return
	print("cDbEditor::on_table_name_edited(" + str(table_id) + ", " + table_name + ")")
	$new_table_dlg.disconnect("create_new_table", self, "on_table_name_edited")
	$new_table_dlg.connect("create_new_table", self, "on_create_table")
	$main_window/tables_panel/tables_list.edit_table_name(table_id, table_name)

func on_delete_table_accepted():
	print("cDbEditor::on_delete_table_accepted()")
	var table_id = $delete_table_dlg.get_table_id()
	m_database.delete_table(table_id)
	$main_window/tables_panel/tables_list.delete_table(table_id)

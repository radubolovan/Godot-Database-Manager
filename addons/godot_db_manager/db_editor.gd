"""
class GDDBEditor
"""

class_name GDDBEditor

tool
extends Tabs

var m_name = ""
var m_database = null

var m_filepath = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	set_tab_align(Tabs.ALIGN_LEFT)
	set_tab_close_display_policy(Tabs.CLOSE_BUTTON_SHOW_ALWAYS)

	$tables_list.connect("resize_tables_list", self, "on_resize_the_table_list")
	$tables_list.connect("add_table", self, "on_add_table")
	$tables_list.connect("edit_table_name", self, "on_edit_table")
	$tables_list.connect("delete_table", self, "on_delete_table")
	$tables_list.connect("select_table", self, "on_select_table")

	$table_editor.connect("set_dirty", self, "on_set_dirty")

	$delete_table_dlg.connect("delete_table", self, "on_confirm_delete_table")

	$new_table_dlg.connect("cancel_dialog", self, "on_close_new_table_dlg")
	$new_table_dlg.get_close_button().connect("pressed", self, "on_close_new_table_dlg")

	$error_dlg.connect("confirmed", self, "on_retry_create_table")

# resizing the tables list
func on_resize_the_table_list(diff_x : float) -> void :
	var size = $tables_list.get_size()
	var min_size = $tables_list.get_custom_minimum_size()
	size.x += diff_x

	if(size.x < min_size.x):
		return

	if(size.x > gddb_constants.c_max_tables_list_width):
		return

	$tables_list.resize_content(size)

	var pos = $table_editor.get_position()
	size = $table_editor.get_size()
	pos.x += diff_x
	size.x -= diff_x
	$table_editor.set_position(pos)
	$table_editor.set_size(size)

# overrides the member from base class
func set_name(ctrl_name) -> void :
	m_name = ctrl_name
	.set_name(ctrl_name)

# sets the database; for easy access
func set_database(db) -> void :
	# print("GDDBEditor::set_database(" + db.get_db_name() + ") to " + get_name())
	m_database = db
	set_dirty(true)

	var tables_count = db.get_tables_count()

	$table_editor.hide()

	for idx in range(0, tables_count):
		var table = db.get_table_at(idx)
		$tables_list.create_table(table, idx == 0)
		if(idx == 0):
			$table_editor.set_table(table)
			$table_editor.link_props()
		$table_editor.show()

# returns the database id
func get_db_id() -> int :
	if(null == m_database):
		return gddb_constants.c_invalid_id
	return m_database.get_db_id()

# returns the database name
func get_db_name() -> String :
	if(null == m_database):
		return ""
	return m_database.get_db_name()

# sets the database to be dirty; should be saved
func set_dirty(dirty) -> void :
	if(dirty):
		var title = m_name + "*"
		.set_name(title)
	else:
		.set_name(m_name)

# called when the user presses the "add_table" button from the "tables_list/tables_header"
func on_add_table() -> void :
	# print("GDDBEditor::on_add_table()")
	$new_table_dlg.set_dld_type(gddb_types.e_new_dlg_type_new)
	$new_table_dlg.set_table_id(gddb_constants.c_invalid_id)
	$new_table_dlg.set_init_name("")
	$new_table_dlg.connect("create_new_table", self, "on_create_table")
	$new_table_dlg.popup_centered()

# called when the user accepts the name of the table in the "new_table_dlg"
func on_create_table(table_name : String) -> void :
	# print("GDDBEditor::on_create_table(" + table_name + ")")
	$new_table_dlg.disconnect("create_new_table", self, "on_create_table")
	var table_id = m_database.add_table(table_name)
	if(table_id == gddb_constants.c_invalid_id):
		$error_dlg.set_text("Table with the name \"" + table_name + "\" already exists" )
		$error_dlg.popup_centered()
		return
	var table = m_database.get_table_by_id(table_id)
	$tables_list.create_table(table)
	$table_editor.set_table(table)
	$table_editor.show()
	m_database.set_dirty(true)
	set_dirty(true)

# called when the user retryes to create a table (changed the name)
func on_retry_create_table() -> void :
	$new_table_dlg.set_init_name("")
	$new_table_dlg.popup_centered()

# called when the user presses the "edit_table_name" from the "tables/list/table"
func on_edit_table(table_id : int, table_name : String) -> void :
	# print("GDDBEditor::on_edit_table(" + str(table_id) + ", " + table_name + ")")
	$new_table_dlg.set_dld_type(gddb_types.e_new_dlg_type_edit)
	$new_table_dlg.set_table_id(table_id)
	$new_table_dlg.set_init_name(table_name)
	$new_table_dlg.connect("create_new_table", self, "on_table_name_edited")
	$new_table_dlg.popup_centered()

# gets called when canceling the new_table_dlg
func on_close_new_table_dlg() -> void :
	# print("GDDBEditor::on_close_new_table_dlg()")
	var dlg_type = $new_table_dlg.get_dlg_type()
	if(dlg_type == gddb_types.e_new_dlg_type_new):
		$new_table_dlg.disconnect("create_new_table", self, "on_create_table")
	elif(dlg_type == gddb_types.e_new_dlg_type_edit):
		$new_table_dlg.disconnect("create_new_table", self, "on_table_name_edited")

# called when the user presses the "delete_table" from the "tables/list/table"
func on_delete_table(table_id : int) -> void :
	# print("GDDBEditor::on_delete_table(" + str(table_id) + ")")
	var table = m_database.get_table_by_id(table_id)
	$delete_table_dlg.set_table_id(table_id)
	$delete_table_dlg.set_table_name(table.get_table_name())
	$delete_table_dlg.popup_centered()

# called when the user accepts the name of the table in the "new_table_dlg"
func on_table_name_edited(table_name : String) -> void :
	# print("GDDBEditor::on_table_name_edited(" + table_name + ")")
	$new_table_dlg.disconnect("create_new_table", self, "on_table_name_edited")
	var table_id = $new_table_dlg.get_table_id()
	if(!m_database.edit_table_name(table_name, table_id)):
		$error_dlg.set_text("Table with the name \"" + table_name + "\" already exists" )
		$error_dlg.popup_centered()
		return
	# print("GDDBEditor::on_table_name_edited(" + str(table_id) + ", " + table_name + ")")
	$tables_list.edit_table_name(table_id, table_name)
	m_database.set_dirty(true)
	set_dirty(true)

# called when the user confirms to delete a table
func on_confirm_delete_table() -> void :
	# print("GDDBEditor::on_confirm_delete_table()")
	var table_id = $delete_table_dlg.get_table_id()
	var selected_table = $tables_list.get_selected_item()
	if(null == selected_table):
		return
	var selected_table_id = selected_table.get_table_id()
	m_database.delete_table_by_id(table_id)
	$tables_list.delete_table(table_id)
	if(selected_table_id == table_id):
		$tables_list.select_item_at(0)
		var table = m_database.get_table_at(0)
		$table_editor.set_table(table)

	m_database.set_dirty(true)
	set_dirty(true)

# called when the user selects a table from the table_list
func on_select_table(table_id : int) -> void :
	var table = m_database.get_table_by_id(table_id)
	if(null != table):
		$table_editor.set_table(table)
		$table_editor.link_props()

# saves current database
func save_database() -> void:
	m_database.save_db()
	set_dirty(false)

# returns true if the database can be saved, otherwise false
func can_save_database() -> bool:
	return !m_database.get_db_filepath().empty()

# sets the database's path
func set_database_filepath(filepath : String) -> void:
	m_database.set_db_filepath(filepath)

# called when a table is modified
func on_set_dirty() -> void:
	m_database.set_dirty(true)
	set_dirty(true)

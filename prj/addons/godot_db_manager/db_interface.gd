tool
extends Control

enum {
	e_action_none = -1
	e_action_new_db = 0,
	e_action_load_db = 1
}

const default_db_name = "database"
var m_current_db_name = ""

var m_database = null

var m_current_table_idx = -1

var m_ctrl_pressed = false

var m_is_saving = false
var m_closing = false

var m_autosave_on_close_enabled = false

var m_action = e_action_none

func _ready() -> void:
	m_database = load("res://addons/godot_db_manager/core/database.gd").new()
	m_action = e_action_none
	m_current_db_name = ""
	setup_connections()
	update_menu_buttons()

func setup_connections() -> void:
	$dlg/menu/new_db_btn.connect("pressed", self, "on_new_database_btn_pressed")
	$dlg/new_db_dlg.add_cancel("Cancel")
	$dlg/new_db_dlg.connect("create_new_db", self, "on_create_db")

	$dlg/confirm_new_db_dlg.connect("confirm_new_database", self, "on_confirm_new_database")

	$dlg/menu/save_db_btn.connect("pressed", self, "on_save_database_btn_pressed")
	$dlg/menu/load_db_btn.connect("pressed", self, "on_load_database_btn_pressed")
	$dlg/menu/new_table_btn.connect("pressed", self, "on_new_table_btn_pressed")
	$dlg/menu/autosave_on_load.connect("toggled", self, "on_toggle_autosave_on_close")

	$dlg/new_table_dlg.add_cancel("Cancel")
	$dlg/new_table_dlg.connect("create_new_table", self, "on_table_created")

	$dlg/tables_container.connect("item_selected", self, "on_select_table")

	$dlg/table.connect("new_property", self, "on_new_property")
	$dlg/table.connect("edit_property", self, "on_edit_property")
	$dlg/table.connect("delete_property", self, "on_delete_property")
	$dlg/table.connect("new_data_row", self, "on_new_data_row")
	$dlg/table.connect("edit_data", self, "on_edit_data")

	$dlg/load_db_dlg.connect("file_selected", self, "on_file_selected")

	$dlg.connect("popup_hide", self, "on_close_dlg")

# update menu buttons
func update_menu_buttons() -> void:
	var disable_buttons = m_current_db_name.empty()
	$dlg/menu/save_db_btn.set_disabled(disable_buttons)
	$dlg/menu/autosave_on_load.set_disabled(disable_buttons)
	$dlg/menu/new_table_btn.set_disabled(disable_buttons)

# these are not working properly; when pressing the "CTRL+S" in the GDScript editor, it gets notified in here as well
"""
func _input(event) -> void:
	if(event is InputEventKey):
		if(event.scancode == KEY_CONTROL):
			m_ctrl_pressed = event.is_pressed()
		elif(event.scancode == KEY_S):
			if(!m_current_db_name.empty()):
				if(event.is_pressed()):
					if(m_ctrl_pressed):
						if(!m_is_saving):
							m_is_saving = true
							on_save_database_btn_pressed()
					else:
						m_is_saving = false
				else:
					m_is_saving = false
			else:
				m_is_saving = false
		elif(event.scancode == KEY_F4):
			if(event.is_pressed()):
				if(m_ctrl_pressed):
					if(!m_closing):
						m_closing = true
						$dlg.hide()
				else:
					m_closing = false
			else:
				m_closing = false
"""

# called when "New DB" button is pressed
func on_new_database_btn_pressed() -> void:
	# check if there's already a database working on
	if(!m_current_db_name.empty()):
		m_action = e_action_new_db
		$dlg/confirm_new_db_dlg.popup_centered()
	else:
		$dlg/new_db_dlg/db_info/db_edt.set_text("")
		$dlg/new_db_dlg.popup_centered()

# called when confirm to create a new database or load one
func on_confirm_new_database() -> void:
	# check if a database should be loaded or created
	if(m_action == e_action_new_db):
		$dlg/new_db_dlg/db_info/db_edt.set_text("")
		$dlg/new_db_dlg.popup_centered()
	else:
		$dlg/load_db_dlg.popup_centered()

# called when creating a new database
func on_create_db(db_name : String) -> void:
	m_database.clear()
	m_current_db_name = db_name
	m_database.set_db_name(m_current_db_name)
	$dlg/menu/current_db_name.set_text("DB path: " + m_database.get_db_path())
	update_menu_buttons()
	$dlg/tables_container.clear()
	$dlg/table.clear_current()
	$dlg/table.hide()

# called when the "Save DB" button is pressed
func on_save_database_btn_pressed() -> void:
	m_database.save_db()

# called when the "Load DB" button is pressed
func on_load_database_btn_pressed() -> void:
	# check if there's already a database working on
	if(!m_current_db_name.empty()):
		m_action = e_action_load_db
		$dlg/confirm_new_db_dlg.popup_centered()
	else:
		$dlg/load_db_dlg.popup_centered()

# enables / disables to autosave the database when the tool is closed
func on_toggle_autosave_on_close(btn_pressed : bool) -> void:
	m_autosave_on_close_enabled = btn_pressed

# called when closing the tool
func on_close_dlg() -> void:
	if(m_autosave_on_close_enabled):
		# automatic save DB when closing the dialog
		on_save_database_btn_pressed()

# called when select a file to be loaded as an database
func on_file_selected(file_path : String) -> void:
	m_current_db_name = file_path

	# remove the ".json"
	m_current_db_name.erase(m_current_db_name.length()-5, 5)

	# remve the path related substring
	var idx = m_current_db_name.find_last("/")
	m_current_db_name.erase(0, idx+1)

	m_database.clear()
	m_database.set_db_name(m_current_db_name)

	$dlg/menu/current_db_name.set_text("DB path: " + file_path)
	var file = File.new()
	file.open(file_path, File.READ)
	var content = file.get_as_text()
	file.close()
	var dictionary = JSON.parse(content).result

	# refresh tables in the database
	$dlg/tables_container.clear()
	var tables = dictionary["tables"]
	for idx in range(0, tables.size()):
		$dlg/tables_container.add_item(tables[idx]["name"])

		var table = m_database.add_table(tables[idx]["name"])

		var props_count = tables[idx]["props"].size()
		if(props_count == 0):
			continue

		for jdx in range(0, props_count):
			table.add_prop(jdx, int(tables[idx]["props"][jdx]["type"]), tables[idx]["props"][jdx]["name"])

		var data_count = tables[idx]["data"].size()
		for jdx in range(0, data_count / props_count):
			var row_data = []
			for kdx in range(0, props_count):
				row_data.push_back(tables[idx]["data"][jdx * props_count + kdx])
			table.add_row(row_data)

	# refresh interface
	$dlg/table.show()
	m_current_table_idx = 0
	$dlg/tables_container.select(m_current_table_idx)
	if(m_database.get_tables_count() > 0):
		$dlg/table.set_table(m_database.get_table_at(m_current_table_idx))

	update_menu_buttons()

func on_new_table_btn_pressed() -> void:
	$dlg/new_table_dlg/table_info/table_edt.set_text("")
	$dlg/new_table_dlg.popup_centered()

func on_table_created(table_name : String) -> void:
	if(m_database.is_table_exists(table_name)):
		$dlg/new_table_dlg/table_info/table_edt.set_text("")
		$dlg/new_table_dlg.popup_centered()
		$dlg/error_dlg.set_text("Table with name \"" + table_name + "\" already exists !")
		$dlg/error_dlg.popup_centered()
		return

	m_current_table_idx = $dlg/tables_container.get_item_count()

	$dlg/tables_container.add_item(table_name)
	$dlg/tables_container.select(m_current_table_idx)

	var table = m_database.add_table(table_name)

	on_select_table(m_current_table_idx)
	$dlg/table.show()

func on_select_table(table_idx : int) -> void:
	var table = m_database.get_table_at(table_idx)
	if(null == table):
		return
	# print("Selecting: " + $tables/HBoxContainer/ItemList.get_item_text(table_idx))
	m_current_table_idx = table_idx
	$dlg/table.set_table(table)

func on_new_property(prop_id : int, prop_type : int, prop_name : String) -> void:
	var table = m_database.get_table_at(m_current_table_idx)
	if(null == table):
		return
	table.add_prop(prop_id, prop_type, prop_name)

func on_edit_property(prop_id : int, prop_type : int, prop_name : String) -> void:
	var table = m_database.get_table_at(m_current_table_idx)
	if(null == table):
		return
	table.edit_prop(prop_id, prop_type, prop_name)

func on_delete_property(prop_id : int) -> void:
	var table = m_database.get_table_at(m_current_table_idx)
	if(null == table):
		return
	table.delete_prop(prop_id)

func on_new_data_row() -> void:
	var table = m_database.get_table_at(m_current_table_idx)
	if(null == table):
		return
	table.add_blank_row()

func get_tables_count() -> int:
	return m_database.get_tables_count()

func get_table_by_name(name : String) -> Object:
	return m_database.get_table_by_name()

func get_table_by_idx(idx : int) -> Object:
	return m_database.get_table_at(idx)

func get_table_name(idx : int) -> String:
	var table = m_database.get_table_at(idx)
	if(null == table):
		return ""
	return table.get_table_name()

func on_edit_data(prop_id : int, row_idx : int, data : String):
	var table = m_database.get_table_at(m_current_table_idx)
	if(null == table):
		return
	table.edit_data(prop_id, row_idx, data)

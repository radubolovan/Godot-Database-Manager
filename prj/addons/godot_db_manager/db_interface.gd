tool
extends Control

var m_current_table_idx = -1
var m_tables = []

var m_ctrl_pressed = false

var m_is_saving = false
var m_closing = false

func _ready():
	$dlg/menu/save_db_btn.connect("pressed", self, "on_save_database_btn_pressed")
	$dlg/menu/load_db_btn.connect("pressed", self, "on_load_database_btn_pressed")
	$dlg/menu/new_table_btn.connect("pressed", self, "on_new_table_btn_pressed")

	$dlg/new_table_dlg.add_cancel("Cancel")
	$dlg/new_table_dlg.connect("create_new_table", self, "on_table_created")

	$dlg/tables_container.connect("item_selected", self, "on_select_table")

	$dlg/table.connect("new_property", self, "on_new_property")
	$dlg/table.connect("change_property", self, "on_change_property")
	$dlg/table.connect("delete_property", self, "on_delete_property")
	$dlg/table.connect("new_data_row", self, "on_new_data_row")
	$dlg/table.connect("update_data", self, "on_update_data")

	$dlg/load_db_dlg.connect("file_selected", self, "on_file_selected")

	#$dlg.get_close_button().connect("pressed", self, "on_close")
	$dlg.connect("popup_hide", self, "on_dlg_hide")

func _input(event):
	if(event is InputEventKey):
		if(event.scancode == KEY_CONTROL):
			m_ctrl_pressed = event.is_pressed()
		elif(event.scancode == KEY_S):
			if(event.is_pressed()):
				if(m_ctrl_pressed):
					if(!m_is_saving):
						m_is_saving = true
						on_save_database_btn_pressed()
				else:
					m_is_saving = false
			else:
				m_is_saving = false
		elif(event.scancode == KEY_F4):
			if(event.is_pressed()):
				if(m_ctrl_pressed):
					if(!m_closing):
						m_closing = true
						print("closinggggggg")
						# hide()
						# queue_free()
				else:
					m_closing = false
			else:
				m_closing = false

func on_save_database_btn_pressed():
	var text = "{"
	text += "\"tables\":["
	for idx in range(0, m_tables.size()):
		text += "{"
		text += "\"name\":\"" + m_tables[idx].get_name() + "\","
		text += "\"props\":["
		for jdx in range(0, m_tables[idx].get_props_count()):
			text += "{"
			text += "\"name\":\"" + str(m_tables[idx].get_prop_name(jdx)) + "\","
			text += "\"type\":\"" + str(m_tables[idx].get_prop_type(jdx)) + "\""
			text += "}"
			if(jdx < m_tables[idx].get_props_count() - 1):
				text += ","
		text += "],"

		text += "\"data\":["
		for jdx in range(0, m_tables[idx].get_data_size()):
			#var the_data = m_tables[idx].get_data_at(jdx)
			#print("getting data at " + str(jdx) + " : " + the_data)
			text += "\"" + m_tables[idx].get_data_at(jdx) + "\""
			if(jdx < m_tables[idx].get_data_size() - 1):
				text += ","
		text += "]" # end of data
		text += "}" # end of table

		if(idx < m_tables.size() - 1):
			text += ","

	text += "]}"

	var save_file = File.new()
	save_file.open("res://database.json", File.WRITE)
	save_file.store_string(text)
	save_file.close()

func on_load_database_btn_pressed():
	$dlg/load_db_dlg.popup_centered()

func on_close():
	print("fucking close")

func on_dlg_hide():
	print("fucking hide")

func on_file_selected(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content = file.get_as_text()
	file.close()
	var dictionary = JSON.parse(content).result

	# refresh tables in the database
	m_tables.clear()
	$dlg/tables_container.clear()
	var tables = dictionary["tables"]
	for idx in range(0, tables.size()):
		$dlg/tables_container.add_item(tables[idx]["name"])

		var table = load("res://addons/godot_db_manager/db_table.gd").new()
		table.set_name(tables[idx]["name"])
		m_tables.push_back(table)

		var props_count = tables[idx]["props"].size()
		for jdx in range(0, props_count):
			table.add_prop(jdx, int(tables[idx]["props"][jdx]["type"]), tables[idx]["props"][jdx]["name"])

		var data_count = tables[idx]["data"].size()
		for jdx in range(0, data_count / props_count):
			var row_data = []
			for kdx in range(0, props_count):
				row_data.push_back(tables[idx]["data"][jdx * props_count + kdx])
			table.add_row(jdx, row_data)

	# refresh interface
	$dlg/table.show()
	m_current_table_idx = 0
	$dlg/tables_container.select(m_current_table_idx)
	if(m_tables.size() > 0):
		$dlg/table.set_table(m_tables[m_current_table_idx])

func deserialize_database(dictionary):
	var tables = dictionary["tables"]
	for idx in range(0, tables.size()):
		print(tables[idx])

func on_new_table_btn_pressed():
	$dlg/new_table_dlg/table_info/table_edt.set_text("")
	$dlg/new_table_dlg.popup_centered()

func on_table_created(table_name):
	if(!can_create_table(table_name)):
		$dlg/new_table_dlg/table_info/table_edt.set_text("")
		$dlg/new_table_dlg.popup_centered()
		$dlg/error_dlg.set_text("Table with name \"" + table_name + "\" already exists !")
		$dlg/error_dlg.popup_centered()
		return

	m_current_table_idx = $dlg/tables_container.get_item_count()

	$dlg/tables_container.add_item(table_name)
	$dlg/tables_container.select(m_current_table_idx)

	var table = load("res://addons/godot_db_manager/db_table.gd").new()
	table.set_name(table_name)
	m_tables.push_back(table)

	on_select_table(m_current_table_idx)
	$dlg/table.show()

func can_create_table(table_name):
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_name() == table_name):
			return false
	return true

func on_select_table(table_idx):
	if(table_idx < 0 || table_idx >= m_tables.size()):
		print("ERROR: database::on_select_table( " + str(table_idx) + " ) havinng " + str(m_tables.size()) + " tables count")
		return
	# print("Selecting: " + $tables/HBoxContainer/ItemList.get_item_text(table_idx))
	m_current_table_idx = table_idx
	$dlg/table.set_table(m_tables[m_current_table_idx])

func on_new_property(prop_id, prop_type, prop_name):
	if(m_current_table_idx < 0 || m_current_table_idx >= m_tables.size()):
		print("ERROR: database::on_new_property( " + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + " ) - wrong m_current_table_idx: " + str(m_current_table_idx) + " - tables count: " + str(m_tables.size()))
		return
	m_tables[m_current_table_idx].add_prop(prop_id, prop_type, prop_name)

func on_change_property(prop_id, prop_type, prop_name):
	if(m_current_table_idx < 0 || m_current_table_idx >= m_tables.size()):
		print("ERROR: database::on_change_property( " + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + " ) - wrong m_current_table_idx: " + str(m_current_table_idx) + " - tables count: " + str(m_tables.size()))
		return
	m_tables[m_current_table_idx].change_prop(prop_id, prop_type, prop_name)

func on_delete_property(prop_id):
	if(m_current_table_idx < 0 || m_current_table_idx >= m_tables.size()):
		print("ERROR: database::on_change_property( " + str(prop_id) + " ) - wrong m_current_table_idx: " + str(m_current_table_idx) + " - tables count: " + str(m_tables.size()))
		return
	m_tables[m_current_table_idx].delete_prop(prop_id)

func on_new_data_row():
	if(m_current_table_idx < 0 || m_current_table_idx >= m_tables.size()):
		print("ERROR: database::on_new_data_row() - wrong m_current_table_idx: " + str(m_current_table_idx) + " - tables count: " + str(m_tables.size()))
		return
	m_tables[m_current_table_idx].add_blank_row()

func get_tables_count():
	return m_tables.size()

func get_table_by_name(name):
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_name() == name):
			return m_tables[idx]
	print("ERROR: database::get_table_by_name( " + name + " ) not found")
	return null

func get_table_by_idx(idx):
	if(idx < 0 || idx > m_tables.size()):
		print("ERROR: database::get_table_by_idx( " + str(idx) + " )")
		return null
	return m_tables[idx]

func get_table_name(idx):
	return m_tables[idx].get_name()

func on_update_data(prop_id, row_idx, data):
	m_tables[m_current_table_idx].update_data(prop_id, row_idx, data)

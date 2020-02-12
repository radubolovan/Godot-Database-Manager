extends Control

var m_current_table_idx = -1
var m_tables = []

func _ready():
	$menu/save_db_btn.connect("pressed", self, "on_save_database")
	$menu/new_table_btn.connect("pressed", self, "on_new_table_btn_pressed")

	$new_table_dlg.add_cancel("Cancel")
	$new_table_dlg.connect("create_new_table", self, "on_table_created")

	$tables_container.connect("item_selected", self, "on_select_table")

	$table.connect("new_property", self, "on_new_property")
	$table.connect("change_property", self, "on_change_property")
	$table.connect("delete_property", self, "on_delete_property")
	$table.connect("new_data_row", self, "on_new_data_row")
	$table.connect("update_data", self, "on_update_data")

func on_save_database():
	var text = "{"
	text += "\"tables\":["
	for idx in range(0, m_tables.size()):
		text += "{" + "\"" + m_tables[idx].get_name() + "\":{"
		text += "\"props\":["
		for jdx in range(0, m_tables[idx].get_props_count()):
			text += "{"
			text += "\"type\":\"" + str(m_tables[idx].get_prop_type(jdx)) + "\","
			text += "\"name\":\"" + str(m_tables[idx].get_prop_name(jdx)) + "\""
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
		text += "]"
		text += "}}"

		if(idx < m_tables.size() - 1):
			text += ","

	text += "]"
	text += "}"

	var save_file = File.new()
	save_file.open("res://database.json", File.WRITE)
	save_file.store_string(text)
	save_file.close()

func on_new_table_btn_pressed():
	$new_table_dlg/table_info/table_edt.set_text("")
	$new_table_dlg.popup_centered()

func on_table_created(table_name):
	if(!can_create_table(table_name)):
		$new_table_dlg/table_info/table_edt.set_text("")
		$new_table_dlg.popup_centered()
		$error_dlg.set_text("Table with name \"" + table_name + "\" already exists !")
		$error_dlg.popup_centered()
		return

	m_current_table_idx = $tables_container.get_item_count()

	$tables_container.add_item(table_name)
	$tables_container.select(m_current_table_idx)

	var table = g_types.cTable.new()
	table.set_name(table_name)
	m_tables.push_back(table)

	on_select_table(m_current_table_idx)
	$table.show()

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
	$table.set_table(m_tables[m_current_table_idx])

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

func get_table_by_idx(idx):
	if(idx < 0 || idx > m_tables.size()):
		print("ERROR: database::get_table_by_idx( " + str(idx) + " )")
		return null
	return m_tables[idx]

func get_table_name(idx):
	return m_tables[idx].get_name()

func on_update_data(prop_id, row_idx, data):
	m_tables[m_current_table_idx].update_data(prop_id, row_idx, data)

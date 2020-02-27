"""
Database class
"""

extends Object

# database types
enum {
	e_db_type_json = 0, # JSON database
	e_db_type_binary = 1 # binary database - to be designed / implemented
}

# database type
var m_db_type = e_db_type_json

# the name of the database
var m_db_name : String = ""

# tables in the database
var m_tables : Array = []

# set the name of the database
# the name of the database should not contain special characters
func set_db_name(name : String) -> bool :
	if(!g_constants.check_db_name(name)):
		print("ERROR: the name of the database \"" + name + "\" contains invalid characters")
		return false
	print("cDatabase::set_db_name(" + name + ")")
	m_db_name = name
	return true

# returns the name of the database
func get_db_name() -> String :
	return m_db_name

# returns the path of the database
func get_db_path() -> String :
	var path = "res://" + m_db_name
	if(m_db_type == e_db_type_json):
		path += ".json"
	return path

# checks if a table with the name "table_name" can be added into database
func can_add_table(table_name : String, table_id : int = -1):
	print("cDatabase::can_add_table(" + table_name + ", " + str(table_id) + ")")
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == table_name):
			if(m_tables[idx].get_table_id() == table_id):
				continue
			print("Warning: table with name \"" + table_name + "\" already exists")
			return false
	return true

# adds a new table
# returns the table; if already exists, it will fire an warning on output console
func add_table(table_name : String) -> Object :
	if(!can_add_table(table_name)):
		return null

	var table_id = generate_new_table_id()

	print("cDatabase::add_table(" + table_name + ")")
	var table = load(g_constants.c_addon_main_path + "core/db_table.gd").new()
	table.set_table_id(table_id)
	table.set_table_name(table_name)
	m_tables.push_back(table)
	return table

# edits a table name
func edit_table_name(table_name : String, table_id : int) -> bool :
	if(!can_add_table(table_name, table_id)):
		return false
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			m_tables[idx].set_table_name(table_name)
			break
	return true

# deletes a table
func delete_table(table_id: int) -> void:
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			print("cDatabase::delete_table(" + str(table_id) + ")")
			m_tables[idx].free()
			m_tables.remove(idx)
			return
	print("cDatabase::delete_table(" + str(table_id) + ") - cannot erase table; id not found")

# generates a new table id
func generate_new_table_id():
	if(m_tables.size() == 0):
		return 0
	return m_tables[m_tables.size()-1].get_property_id() + 1

# returns the count of the tables in the database
func get_tables_count() -> int :
	return m_tables.size()

# returns true if the table exists in the database, false otherwise
# this is equivalent with (get_table_by_name(table name) != null) function, but without firing the error in case the table doesn't exist
func is_table_exists(table_name : String) -> bool:
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == table_name):
			return true
	return false

# returns a table by an index or null if the index is invalid
func get_table_at(idx: int) -> Object :
	if(idx < 0 || idx >= m_tables.size()):
		print("ERROR: cannot obtain table with index " + str(idx))
		return null
	return m_tables[idx]

# returns a table by its name or null if the name of the table doesn's exist
func get_table_by_name(name: String) -> Object :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == name):
			return m_tables[idx]
	print("ERROR: cannot obtain table with name \"" + name + "\"")
	return null

# deletes all the tables
func clear() -> void :
	print("cDatabase::clear()")
	for idx in range(0, m_tables.size()):
		m_tables[idx].clear()
	m_tables.clear()

# serialization
func save_db() -> void :
	if(m_db_name.empty()):
		print("ERROR: save_db() - current database doen't have a name")
		return

	print("cDatabase::save_db()")
	var text = "{"
	text += "\"tables\":["
	for idx in range(0, m_tables.size()):
		text += "{"
		text += "\"name\":\"" + m_tables[idx].get_table_name() + "\","
		text += "\"props\":["
		for jdx in range(0, m_tables[idx].get_props_count()):
			var db_prop = m_tables[idx].get_prop_at(jdx)
			text += "{"
			text += "\"name\":\"" + str(db_prop.get_prop_name()) + "\","
			text += "\"type\":\"" + str(db_prop.get_prop_type()) + "\""
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
	save_file.open(get_db_path(), File.WRITE)
	save_file.store_string(text)
	save_file.close()

# deserialization
func load_db() -> void :
	if(m_db_name.empty()):
		print("ERROR: load_db() - current database doen't have a name")
		return

	var file = File.new()
	file.open(get_db_path(), File.READ)
	var content = file.get_as_text()
	file.close()
	var dictionary = JSON.parse(content).result

	clear()
	var tables = dictionary["tables"]
	for idx in range(0, tables.size()):
		var table = add_table(tables[idx]["name"])

		var props_count = tables[idx]["props"].size()
		if(props_count == 0):
			continue
	
		for jdx in range(0, props_count):
				table.add_prop(int(tables[idx]["props"][jdx]["type"]), tables[idx]["props"][jdx]["name"])
	
		var data_count = tables[idx]["data"].size()
		for jdx in range(0, data_count / props_count):
			var row_data = []
			for kdx in range(0, props_count):
				row_data.push_back(tables[idx]["data"][jdx * props_count + kdx])
			table.add_row(row_data)

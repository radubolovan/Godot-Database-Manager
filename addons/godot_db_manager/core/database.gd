"""
GDDatabase class
"""

class_name GDDatabase

extends Object

# database types
enum {
	e_db_type_json = 0, # JSON database
	e_db_type_binary = 1 # binary database - to be designed / implemented
}

# database type
var m_db_type : int = e_db_type_json

# the id of the database
var m_db_id : int = gddb_constants.c_invalid_id

# the name of the database
var m_db_name : String = ""

# tables in the database
var m_tables : Array = []

# the path of the database
var m_db_filepath : String = ""

# if the database is not saved, it is dirty
var m_is_dirty : bool = false

# sets the id of the database
func set_db_id(db_id : int) -> void :
	m_db_id = db_id

# returns the database id
func get_db_id() -> int :
	return m_db_id

# set the name of the database
# the name of the database should not contain special characters
func set_db_name(db_name : String) -> bool :
	if(!gddb_globals.check_db_name(db_name)):
		print("ERROR: GDDatabase::set_db_name(" + db_name + ") - the name of the database contains invalid characters")
		return false
	# print("GDDatabase::set_db_name(" + db_name + ")")
	m_db_name = db_name
	return true

# returns the name of the database
func get_db_name() -> String :
	return m_db_name

# sets the database file path
func set_db_filepath(filepath : String) -> void :
	m_db_filepath = filepath

# returns the path of the database
func get_db_filepath() -> String :
	return m_db_filepath

# checks if a table with the name "table_name" can be added into database
func can_add_table(table_name : String, table_id : int = -1) -> bool :
	# print("GDDatabase::can_add_table(" + table_name + ", " + str(table_id) + ")")
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == table_name):
			if(m_tables[idx].get_table_id() == table_id):
				continue
			print("WARNING: GDDatabase::can_add_table(" + table_name + ", " + str(table_id) + ") - table already exists")
			return false
	return true

# adds a new table
# returns the table id; if already exists, it will fire an warning on output console and returns an invalid id
func add_table(table_name : String) -> int :
	if(!can_add_table(table_name)):
		print("WARNING: GDDatabase::add_table(" + table_name + ") - cannot add table")
		return gddb_constants.c_invalid_id

	# print("GDDatabase::add_table(" + table_name + ") to \"" + m_db_name + "\" database")

	var table_id = generate_new_table_id()
	var table = load(gddb_constants.c_addon_main_path + "core/db_table.gd").new()
	table.set_table_id(table_id)
	table.set_table_name(table_name)
	table.set_parent_database(self)
	m_tables.push_back(table)
	return table_id

# edits a table name
func edit_table_name(table_name : String, table_id : int) -> bool :
	if(!can_add_table(table_name, table_id)):
		return false
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			m_tables[idx].set_table_name(table_name)
			break
	return true

# deletes a table at index
func delete_table_at(idx : int) -> void :
	if(idx < 0 || idx > m_tables.size() - 1):
		print("GDDatabase::delete_table_at(" + str(idx) + ") - index out of bounds")
		return
	m_tables[idx].clear()
	m_tables[idx].free()
	m_tables.remove(idx)

# deletes a table by id
func delete_table_by_id(table_id: int) -> void :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			# print("GDDatabase::delete_table_by_id(" + str(table_id) + ")")
			m_tables[idx].clear()
			m_tables[idx].free()
			m_tables.remove(idx)
			return
	print("ERROR: GDDatabase::delete_table_by_id(" + str(table_id) + ") - cannot erase table; id not found")

# deletes a table by name
func delete_table_by_name(table_name: String) -> void :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == table_name):
			# print("GDDatabase::delete_table_by_name(" + table_name + ")")
			m_tables[idx].clear()
			m_tables[idx].free()
			m_tables.remove(idx)
			return
	print("ERROR: GDDatabase::delete_table_by_name(" + table_name + ") - cannot erase table; name not found")

# generates a new table id
func generate_new_table_id() -> int :
	if(m_tables.size() == 0):
		return 0
	return m_tables[m_tables.size()-1].get_table_id() + 1

# returns the count of the tables in the database
func get_tables_count() -> int :
	return m_tables.size()

# returns true if the table exists in the database, false otherwise
# this is equivalent with (get_table_by_name(table name) != null) function, but without firing the error in case the table doesn't exist
func is_table_exists(table_name : String) -> bool :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == table_name):
			return true
	return false

# returns a table by an index or null if the index is invalid
func get_table_at(idx: int) -> Object :
	if(idx < 0 || idx >= m_tables.size()):
		print("ERROR: GDDatabase::get_table_at(" + str(idx) + ") - cannot obtain table with index")
		return null
	return m_tables[idx]

# returns a table by its id or null if a table with id doesn's exist
func get_table_by_id(table_id: int) -> Object :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			return m_tables[idx]
	print("ERROR: GDDatabase::get_table_by_id(" + str(table_id) + ") - cannot obtain table with id")
	return null

# returns a table by its name or null if the name of the table doesn's exist
func get_table_by_name(table_name: String) -> Object :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == table_name):
			return m_tables[idx]
	print("ERROR: GDDatabase::get_table_by_id(" + table_name + ") - cannot obtain table with name")
	return null

# deletes all the tables
func clear() -> void :
	# print("GDDatabase::clear()")
	m_db_name = ""
	for idx in range(0, m_tables.size()):
		m_tables[idx].clear()
	m_tables.clear()

# sets the database dirty; it is not saved
func set_dirty(dirty : bool) -> void :
	m_is_dirty = dirty

# returns true if a database is dirty (should be saved), false otherwise
func is_dirty() -> bool :
	return m_is_dirty

# serialization
func save_db() -> void :
	if(m_db_name.empty()):
		print("ERROR: GDDatabase::save_db() - current database doesn't have a name")
		return

	if(m_db_filepath.empty()):
		print("ERROR: GDDatabase::save_db() - current database doesn't have a path file")
		return

	# print("GDDatabase::save_db() - " + m_db_name + " to: " + m_db_filepath)
	var text = "{"
	text += "\n\t\"" + gddb_constants.c_gddb_signature + "\":\"" + gddb_constants.c_gddb_ver + "\","
	text += "\n\t\"db_name\":\"" + m_db_name + "\","
	text += "\n\t\"tables\":["
	for idx in range(0, m_tables.size()):
		text += "\n\t\t{"
		text += "\n\t\t\t\"table_name\":\"" + m_tables[idx].get_table_name() + "\","
		text += "\n\t\t\t\"props\":["
		for jdx in range(0, m_tables[idx].get_props_count()):
			var db_prop = m_tables[idx].get_prop_at(jdx)
			text += "\n\t\t\t\t\t{"
			text += "\"name\":\"" + str(db_prop.get_prop_name()) + "\","

			var prop_type = db_prop.get_prop_type()
			if(prop_type < gddb_types.e_prop_types_count):
				text += "\"type\":\"" + str(prop_type) + "\","
			else:
				# print("GDDatabase::save_db() - prop_type: " + str(prop_type))
				var table_id = prop_type - gddb_types.e_prop_types_count
				var table = get_table_by_id(table_id)
				if(null == table):
					print("GDDatabase::save_db() - table not found with id: " + str(table_id))
				text += "\"type\":\"" + "table" + "\","
				text += "\"table_name\":\"" + table.get_table_name() + "\","

			text += "\"auto_increment\":\"" + str(int(db_prop.has_autoincrement())) + "\""

			text += "}"
			if(jdx < m_tables[idx].get_props_count() - 1):
				text += ","
		text += "\n\t\t\t],"

		text += "\n\t\t\t\"data\":["
		for jdx in range(0, m_tables[idx].get_data_size()):
			#var the_data = m_tables[idx].get_data_at(jdx)
			#print("getting data at " + str(jdx) + " : " + the_data)
			text += "\"" + m_tables[idx].get_data_at(jdx) + "\""
			if(jdx < m_tables[idx].get_data_size() - 1):
				text += ","
		text += "]" # end of data
		text += "\n\t\t}" # end of table

		if(idx < m_tables.size() - 1):
			text += ","

	text += "\n\t]\n}"

	var save_file = File.new()
	save_file.open(m_db_filepath, File.WRITE)
	save_file.store_string(text)
	save_file.close()

	set_dirty(false)

# deserialization
func load_db() -> int :
	var file = File.new()
	file.open(get_db_filepath(), File.READ)
	var content = file.get_as_text()
	file.close()
	var dictionary = JSON.parse(content).result

	# check the signature
	if(!dictionary.has(gddb_constants.c_gddb_signature)):
		print("GDDatabase::load_db() - invalid database file")
		return gddb_types.e_db_invalid_file

	var gddb_signature = dictionary[gddb_constants.c_gddb_signature]
	if(gddb_signature != gddb_constants.c_gddb_ver):
		print("GDDatabase::load_db() - invalid database version")
		return gddb_types.e_db_invalid_ver

	clear()
	m_db_name = dictionary["db_name"]
	var tables = dictionary["tables"]
	for idx in range(0, tables.size()):
		var table_id = add_table(tables[idx]["table_name"])
		var table = get_table_by_id(table_id)

		var props_count = tables[idx]["props"].size()
		if(props_count == 0):
			continue
	
		for jdx in range(0, props_count):
			var prop_type = tables[idx]["props"][jdx]["type"]

			var prop_id = -1
			if(prop_type == "table"):
				var table_name = tables[idx]["props"][jdx]["table_name"]
				prop_id = table.add_table_prop(tables[idx]["props"][jdx]["name"], table_name)
			else:
				prop_id = table.add_prop(int(prop_type), tables[idx]["props"][jdx]["name"])

			var prop = table.get_prop_by_id(prop_id)
			var enable_autoincrement = tables[idx]["props"][jdx]["auto_increment"].to_int()
			prop.enable_autoincrement(bool(enable_autoincrement))
	
		var data_count = tables[idx]["data"].size()
		#print("********* set data to db - begin")
		for jdx in range(0, data_count / props_count):
			var row_data = []
			for kdx in range(0, props_count):
				var cell_data = tables[idx]["data"][jdx * props_count + kdx]
				# print("cell_data: " + cell_data)
				row_data.push_back(cell_data)
			#print("row_data: " + str(row_data))
			table.add_row(row_data)
		#print("********* set data to db - end")

	# link custom data to tables
	for idx in range(0, m_tables.size()):
		m_tables[idx].link_tables_props()

	return gddb_types.e_db_valid

# dumps the database
func dump() -> String :
	var dump_text = "\nDatabase dump. id: " + str(m_db_id) + ", name: " + m_db_name + ", filepath: " + m_db_filepath
	dump_text += "\n------------------------------------------------------------------------------------\n"

	for idx in range(0, m_tables.size()):
		dump_text += "\n" + m_tables[idx].dump()

	return dump_text

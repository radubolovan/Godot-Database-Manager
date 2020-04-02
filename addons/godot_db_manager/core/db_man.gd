"""
GDDBMan class
"""

class_name GDDBMan

extends Object

var m_databases = []

# adds a database
func add_database(db_name : String) -> int :
	if(!can_add_db(db_name)):
		print("ERROR: GDDBMan::add_database(" + db_name + ") already exists")
		return gddb_constants.c_invalid_id
	# print("GDDBMan::add_database(" + db_name + ")")
	var db_id = generate_new_db_id()
	var db = load(gddb_constants.c_addon_main_path + "core/database.gd").new()
	db.set_db_id(db_id)
	db.set_db_name(db_name)
	m_databases.push_back(db)
	return db_id

# loads a database from a file
func load_database(filepath : String) -> int :
	var db_id = generate_new_db_id()
	var db = load(gddb_constants.c_addon_main_path + "core/database.gd").new()
	db.set_db_id(db_id)
	db.set_db_filepath(filepath)

	if(db.load_db() == gddb_types.e_db_invalid_file):
		db.free()
		return gddb_types.e_db_invalid_file

	elif(db.load_db() == gddb_types.e_db_invalid_ver):
		db.free()
		return gddb_types.e_db_invalid_ver

	m_databases.push_back(db)
	return db_id

# erases a database at index
# it does not erase the database file
func erase_db_at(idx : int) -> void :
	if(idx < 0 || idx > m_databases.size() - 1):
		print("ERROR: GDDBMan::erase_db_at(" + str(idx) + ") - index out of bounds")

	m_databases[idx].clear()
	m_databases[idx].free()
	m_databases.remove(idx)

# erases a database by id
# it does not erase the database file
func erase_db_by_id(db_id : int) -> void :
	var db_found = false
	for idx in range(0, m_databases.size()):
		if(m_databases[idx].get_db_id() == db_id):
			m_databases[idx].clear()
			m_databases[idx].free()
			m_databases.remove(idx)
			db_found = true
			break

	if(!db_found):
		print("ERROR: GDDBMan::erase_db_by_id(" + str(db_id) + ") - database not found")

# erases a database by name
# it does not erase the database file
func erase_db_by_name(db_name : String) -> void :
	var db_found = false
	for idx in range(0, m_databases.size()):
		if(m_databases[idx].get_db_name() == db_name):
			m_databases[idx].clear()
			m_databases[idx].free()
			m_databases.remove(idx)
			db_found = true
			break

	if(!db_found):
		print("ERROR: GDDBMan::erase_db_by_id(" + db_name + ") - database not found")

# returns the databases count
func get_databases_count() -> int :
	return m_databases.size()

# returns a database at index
func get_db_at(idx : int) -> Object :
	if(idx < 0 || idx >= m_databases.size()):
		print("ERROR: GDDBMan::get_db_at(" + str(idx) + ") - invalid index")
		return null
	return m_databases[idx]

# returns a database by an id
func get_db_by_id(db_id : int) -> Object :
	for idx in range(0, m_databases.size()):
		if(m_databases[idx].get_db_id() == db_id):
			return m_databases[idx]
	print("ERROR: GDDBMan::get_db_by_id(" + str(db_id) + ") - invalid id")
	return null

# returns a database by a name
func get_db_by_name(db_name : String) -> Object :
	for idx in range(0, m_databases.size()):
		if(m_databases[idx].get_db_name() == db_name):
			return m_databases[idx]
	return null

# generates a new table id
func generate_new_db_id() -> int :
	if(m_databases.size() == 0):
		return 0
	return m_databases[m_databases.size()-1].get_db_id() + 1

# checks if a database already exists
func can_add_db(db_name : String) -> bool :
	for idx in range(0, m_databases.size()):
		if(m_databases[idx].get_db_name() == db_name):
			print("ERROR: Database with name \"" + db_name + "\" already exists")
			return false
	return true

# deletes all databases
func clear() -> void :
	for idx in range(0, m_databases.size()):
		m_databases[idx].clear()
		m_databases[idx].free()
	m_databases.clear()

# dumps all databases
func dump(to_console : bool = false) -> String :
	var dump_text = "\nDatabase manager - dump"

	dump_text += "\n===================================================================================="
	for idx in range(0, m_databases.size()):
		dump_text += m_databases[idx].dump()
	dump_text += "===================================================================================="

	if(to_console):
		print(dump_text)

	return dump_text

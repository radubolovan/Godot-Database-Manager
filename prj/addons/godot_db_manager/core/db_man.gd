"""
GDDBMan class
"""

class_name GDDBMan

extends Object

var m_databases = []
var m_current_database_id = g_constants.c_invalid_id

# adds a database
func add_database(db_name : String) -> int:
	if(!can_add_db(db_name)):
		return g_constants.c_invalid_id
	var db_id = generate_new_db_id()
	var db = load(g_constants.c_addon_main_path + "core/database.gd").new()
	db.set_db_id(db_id)
	db.set_db_name(db_name)
	m_databases.push_back(db)
	if(m_databases.size() == 1):
		m_current_database_id = db_id
	return m_current_database_id

# sets the current_database at index
func set_current_db_at(idx : int) -> void:
	if(idx < 0 || idx >= m_databases.size()):
		print("ERROR: GDDBMan::set_current_db_at(" + str(idx) + ") - invalid index")
		return
	# print("GDDBMan::set_current_db_at(" + str(idx) + ") - db: " + str(m_databases[idx]))
	m_current_database_id = m_databases[idx].get_db_id()

# sets the current_database by id
func set_current_db_id(db_id : int) -> void:
	m_current_database_id = db_id

# returns the current database id
func get_current_db_id() -> int :
	return m_current_database_id

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
func generate_new_db_id() -> int:
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

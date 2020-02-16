"""
Database class
"""

extends Node

# database types
enum {
	e_db_type_json = 0, # JSON database
	e_db_type_binary = 1 # binary database - to be designed / implemented
}

# characters that should not be part of the database name
const c_forbidden_characters = "`@#$%^&*\\|;:'\",<.>/?"

# database type
var m_db_type = e_db_type_json

# the name of the database
var m_name : String = ""

# tables in the database
var m_tables : Array = []

# checks the name of the database
func check_db_name(name : String) -> bool :
	for idx in range(0, name.length()):
		for jdx in range(0, c_forbidden_characters.length()):
			if(name[idx] == c_forbidden_characters[jdx]):
				return false
	return true

# set the name of the database
# the name of the database should not contain special characters
func set_db_name(name : String) -> bool :
	if(!check_db_name(name)):
		print("ERROR: the name of the database \"" + name + "\" contains invalid characters")
		return false
	m_name = name
	return true

# returns the name of the database
func get_db_name() -> String :
	return m_name

# returns the path of the database
func get_db_path() -> String :
	var path = "res://" + name
	if(m_db_type == e_db_type_json):
		path += ".json"
	return path

# add a new table
# returns false if a table with the same name exists, otherwise create the table and returns true
func add_table(name : String) -> bool :
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == name):
			print("ERROR: table with name \"" + name + "\" already exists")
			return false
	var table = load("res://addons/godot_db_manager/core/db_table.gd").new()
	table.set_table_name(name)
	m_tables.push_back(table)
	return true

# returns the count of the tables in the database
func get_tables_count() -> int :
	return m_tables.size()

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
	for idx in range(0, m_tables.size()):
		m_tables[idx].clear()
	m_tables.clear()

# serialization
func save_db() -> void :
	pass

# deserialization
func load_db(path: String) -> void :
	pass

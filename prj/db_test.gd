extends Control

const c_db_name = "database"

var m_database = null

func _ready():
	#test_new_database()
	test_load_database()

func test_new_database() -> void:
	# create a database and set its name
	m_database = load("res://addons/godot_db_manager/core/database.gd").new()
	m_database.set_db_name(c_db_name)

	# create "resources" table
	var resources_tbl = m_database.add_table("resources")

	# add properties to "resources" table
	resources_tbl.add_prop(0, gd_types.e_prop_type_int, "ID")
	resources_tbl.add_prop(1, gd_types.e_prop_type_string, "name")
	resources_tbl.add_prop(2, gd_types.e_prop_type_string, "path")

	# add data to "resources" table
	var data = [
		[0, "Silver", "res://resources/silver.png"],
		[1, "Gold", "res://resources/gold.png"],
		[2, "Diamond", "res://resources/diamond.png"]
	]
	resources_tbl.add_row(data[0])
	resources_tbl.add_row(data[1])
	resources_tbl.add_row(data[2])

	# create "users" table
	var users_tbl = m_database.add_table("users")

	# add properties to "users" table
	users_tbl.add_prop(0, gd_types.e_prop_type_int, "ID")
	users_tbl.add_prop(1, gd_types.e_prop_type_string, "name")

	# add data to "users" table
	data = [
		[0, "User_1"],
		[1, "User_2"],
		[2, "User_3"]
	]
	users_tbl.add_row(data[0])
	users_tbl.add_row(data[1])
	users_tbl.add_row(data[2])

	m_database.save_db()

func test_load_database() -> void:
	# create a database and set its name
	m_database = load("res://addons/godot_db_manager/core/database.gd").new()
	m_database.set_db_name(c_db_name)
	
	# load database
	m_database.load_db()

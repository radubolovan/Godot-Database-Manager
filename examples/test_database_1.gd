"""
test_database_1.gd
Testing Godot Database helper script
"""

extends Node

const c_base_dbs_path = "res://examples/"
const c_database_name = "test_database"

var m_db_man = null

func _ready():
	randomize()

	test_1()


# test 1:
# 1) init DB manager
# 2) create a database
# 3) create a table
# 4) create 2 properties: id(integer; autoincrement) and name(string)
# 5) add 100 data rows (random strings)
# 6) dump db_man
# 7) save database
# 8) clear db_man
# 9) load database
# 10) dump db_man
# 11) done db_man
func test_1() -> void :
	OS.set_window_size(Vector2(640, 480))

	# init db_manager
	init_db_man()

	# create a database
	var db = create_database(c_database_name)

	# create a table
	var table_id = db.add_table("table")
	var table = db.get_table_by_id(table_id)

	# create "id" property with autoincrement option
	var prop_id = table.add_prop(gddb_types.e_prop_type_int, "id")
	var prop = table.get_prop_by_id(prop_id)
	prop.enable_autoincrement(true)

	# create "name" property
	prop_id = table.add_prop(gddb_types.e_prop_type_string, "name")

	# create 100 data rows of data
	for idx in range(0, 100):
		var data = []
		data.push_back(idx) # TODO: this is redundant if the property has autoincrement option
		data.push_back("data_%03d" % (idx + 1))
		table.add_row(data)

	# dump db_man
	m_db_man.dump(true)

	# save the database
	db.save_db()

	# clear db_man
	m_db_man.clear()

	# load the database previously created
	m_db_man.load_database(c_base_dbs_path + c_database_name + ".json")

	# dump db_man
	m_db_man.dump(true)

	# done db_man
	done_db_man()


### helper functions

# init database manager
func init_db_man() -> void :
	m_db_man = load(gddb_constants.c_addon_main_path + "core/db_man.gd").new()

# destroys database manager
func done_db_man() -> void :
	m_db_man.clear()
	m_db_man.free()
	m_db_man = null

# creates a database
func create_database(db_name : String) -> Object:
	var db_id = m_db_man.add_database(db_name)
	var db = m_db_man.get_db_by_id(db_id)
	db.set_db_filepath(c_base_dbs_path + db_name + ".json")
	return db

"""
test_database.gd
Testing Godot Database helper script
"""

extends Node

const c_base_dbs_path = "res://examples/"
const c_database_name = "test_database"

var m_db_man = null

func _ready():
	randomize()

	test_2()


# test 2:
# 1) init DB manager
# 2) create a database
# 3) create 10 tables
# 4) dump db_man
# 5) save database
# 8) clear db_man
# 9) load database
# 10) randomly erase 3 tables
# 11) dump db_man
# 12) done db_man
func test_2() -> void:
	OS.set_window_size(Vector2(640, 480))

	# init db_manager
	init_db_man()

	# create a database
	var db = create_database(c_database_name)

	# create 10 tables
	for idx in range(0, 10):
		var table_id = db.add_table("table_" + str(idx + 1))

	# dump db_man
	m_db_man.dump(true)

	# save the database
	db.save_db()

	# clear db_man
	m_db_man.clear()

	# load the database previously created
	var db_id = m_db_man.load_database(c_base_dbs_path + c_database_name + ".json")
	db = m_db_man.get_db_by_id(db_id)

	# randomly erase 3 tables
	for idx in range(0, 3):
		var table_idx = randi() % db.get_tables_count()
		var table = db.get_table_at(table_idx)
		print("Erasing table with id: " + str(table.get_table_id()))
		db.delete_table_at(table_idx)

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

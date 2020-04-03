"""
test_db_manager.gd
Testing Godot Database Manager helper script
"""

extends Node

const c_base_dbs_path = "res://tests/"

var m_db_man = null

func _ready():
	randomize()

	test_1()


#### tests

# test 1 => create / save / load / erase databases test
func test_1() -> void :
	OS.set_window_size(Vector2(640, 480))

	# init db_manager
	init_db_man()

	# create 10 databases
	for idx in range(0, 10):
		var db_name = "db_%02d" % idx
		create_database(db_name)

	# dump database manager
	m_db_man.dump(true)

	# save all databases
	for idx in range(0, m_db_man.get_databases_count()):
		var db = m_db_man.get_db_at(idx)
		db.save_db()

	# clear db_man
	m_db_man.clear()

	# loaded all databases previously created
	for idx in range(0, 10):
		var db_name = "db_%02d" % idx
		m_db_man.load_database(c_base_dbs_path + db_name + ".json")

	# dump database manager
	m_db_man.dump(true)

	# randomly erase 3 databases
	for idx in range(0, 3):
		var db_idx = randi() % m_db_man.get_databases_count()
		var db = m_db_man.get_db_at(db_idx)
		print("Erasing database with id: " + str(db.get_db_id()))
		m_db_man.erase_db_at(db_idx)

	# dump database manager
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
func create_database(db_name : String) -> void:
	var db_id = m_db_man.add_database(db_name)
	var db = m_db_man.get_db_by_id(db_id)
	db.set_db_filepath(c_base_dbs_path + db_name + ".json")

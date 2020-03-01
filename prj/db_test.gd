extends Control

const c_db_name = "database"

var m_database = null

func _ready():
	#test_new_database()
	test_load_database()

func test_new_database() -> void:
	# create a database and set its name
	m_database = load(g_constants.c_addon_main_path + "core/database.gd").new()
	m_database.set_db_name(c_db_name)
	m_database.set_db_filepath("res://database.json")

	# create "resources" table
	var resources_tbl = m_database.add_table("resources")

	# add properties to "resources" table
	resources_tbl.add_prop(db_types.e_prop_type_int, "ID")
	resources_tbl.add_prop(db_types.e_prop_type_string, "name")
	resources_tbl.add_prop(db_types.e_prop_type_string, "path")

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
	users_tbl.add_prop(db_types.e_prop_type_int, "ID")
	users_tbl.add_prop(db_types.e_prop_type_string, "name")

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
	m_database = load(g_constants.c_addon_main_path + "core/database.gd").new()
	m_database.set_db_name(c_db_name)
	m_database.set_db_filepath("res://database.json")
	
	# load database
	m_database.load_db()

	# get tables count
	var tables_count = m_database.get_tables_count()
	print("Tables count : " + str(tables_count))

	# dump the database
	for idx in range(0, tables_count):
		var table = m_database.get_table_at(idx)
		print("====================")
		print("Table name: " + table.get_table_name())

		var props_count = table.get_props_count()
		print("Properties count: " + str(props_count))

		# dump database's properties
		for jdx in range(0, props_count):
			var prop = table.get_prop_at(jdx)
			print("Property name: " + prop.get_prop_name() + ", property type: " + db_types.get_data_name(prop.get_prop_type()))

		# dump database's data
		var rows_count = table.get_rows_count()
		print("Rows count: " + str(rows_count))
		for jdx in range(0, rows_count):
			var row = table.get_data_at_row_idx(jdx)
			var data_count = row.size()
			for kdx in range(0, data_count):
				print("Data: " + row[kdx].get_data())
		print("====================")

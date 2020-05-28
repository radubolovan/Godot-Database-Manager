"""
GDDBTable class
"""

class_name GDDBTable

extends Object

var m_table_id : int = gddb_constants.c_invalid_id
var m_table_name : String = ""
var m_props : Array = []
var m_data : Array = []
var m_rows_count : int = 0

var m_parent_database : Object = null

# sets the table id
func set_table_id(table_id : int) -> void :
	# print("GDDBDTable::set_table_id(" + str(table_id) + ")")
	m_table_id = table_id

# returns the table id
func get_table_id() -> int :
	return m_table_id

# sets the table name
func set_table_name(table_name: String) -> void :
	# print("GDDBDTable::set_table_name(" + table_name + ")")
	m_table_name = table_name

# returns the table name
func get_table_name() -> String :
	return m_table_name

# sets the parent database
func set_parent_database(db : Object) -> void :
	# print("GDDBTable::set_parent_database(" + str(db) + ")")
	m_parent_database = db

# returns parent database
func get_parent_database() -> Object :
	return m_parent_database

# adds a property in the table structure as a base type
# returns prop ID
func add_prop(prop_type : int, prop_name : String) -> int :
	var prop_id = generate_new_prop_id()

	# print("GDDBDTable::add_prop(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ")")
	var prop = load(gddb_constants.c_addon_main_path + "core/db_prop.gd").new()
	prop.set_prop_id(prop_id)
	prop.set_prop_type(prop_type)
	prop.set_prop_name(prop_name)
	m_props.push_back(prop)

	# adding blank data to all existing rows
	# TODO: find a way to make this better; this is ugly
	if(m_data.size() > 0):
		var new_data_array = []
		var data_idx = 0
		var row_idx = 0
		while(true):
			var data = m_data[data_idx]
			row_idx = data.get_row_idx()
			if(data.get_prop_id() + 1 == prop_id):
				new_data_array.push_back(data)
				var new_data = load(gddb_constants.c_addon_main_path + "core/db_data.gd").new()
				new_data.set_prop_id(prop_id)
				new_data.set_row_idx(row_idx)

				if(prop_type == gddb_types.e_prop_type_bool):
					new_data.set_data("0")
		
				elif(prop_type == gddb_types.e_prop_type_int):
					if(prop.has_autoincrement()):
						new_data.set_data(str(m_rows_count+1))
					else:
						new_data.set_data("0")
		
				elif(prop_type == gddb_types.e_prop_type_float):
					new_data.set_data("0.0")
		
				elif(prop_type == gddb_types.e_prop_type_string):
					new_data.set_data("")
		
				elif(prop_type == gddb_types.e_prop_type_resource):
					new_data.set_data("res://")
		
				elif(prop_type >= gddb_types.e_prop_types_count):
					new_data.set_data(str(-1))

				new_data_array.push_back(new_data)
			else:
				new_data_array.push_back(data)
	
			data_idx += 1
			if(data_idx >= m_data.size()):
				break

		m_data.clear()
		for idx in range(0, new_data_array.size()):
			m_data.push_back(new_data_array[idx])

	return prop_id

# adds a property in the table structure as a table type
# returns prop ID
func add_table_prop(prop_name : String, table_name : String) -> int :
	# print("GDDBTable::add_table_prop(" + prop_name + ", " + table_name + ")")
	var prop_id = generate_new_prop_id()

	# print("GDDBDTable::add_prop(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ")")
	var prop = load(gddb_constants.c_addon_main_path + "core/db_prop.gd").new()
	prop.set_prop_id(prop_id)
	prop.set_prop_name(prop_name)
	prop.set_prop_custom_type(table_name)
	m_props.push_back(prop)

	return prop_id

# links custom properties from tables
func link_tables_props() -> void :
	for idx in range(0, m_props.size()):
		var custom_prop_type = m_props[idx].get_prop_custom_type()
		if(!custom_prop_type.empty()):
			var table = m_parent_database.get_table_by_name(custom_prop_type)
			m_props[idx].set_prop_type(gddb_types.e_prop_types_count + table.get_table_id())
			m_props[idx].set_prop_custom_type("")

# edits a property in the table structure
func edit_prop(prop_id : int, prop_type : int, prop_name: String) -> void :
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			m_props[idx].set_prop_type(prop_type)
			m_props[idx].set_prop_name(prop_name)
			return

	print("ERROR: GDDBDTable::edit_prop(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ") - property not found")

# enables or disables autoincrement on a property
func enable_prop_autoincrement(prop_id : int, enable : bool) -> void :
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			m_props[idx].enable_autoincrement(enable)
			break

# deletes a property and all the data from the table have the same property
func delete_prop(prop_id : int) -> void :
	# print("db_table::delete_prop(" + str(prop_id) + ")")
	var prop_found = false
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			# print("Removing prop with id " + str(prop_id))
			m_props[idx].free()
			m_props.remove(idx)
			prop_found = true
			break

	if(!prop_found):
		print("ERROR: GDDBDTable::delete_prop( " + str(prop_id) + " ) - property not found !")
		return

	# remove the data
	# this is very ugly, but I can't erase a subarray from an array in GDscript :(
	# backup what needs to be saved only
	var tmp_data = []
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_prop_id() == prop_id):
			continue
		tmp_data.push_back(m_data[idx])
	# clear and restore data
	m_data.clear()
	for idx in range(0, tmp_data.size()):
		m_data.push_back(tmp_data[idx])

# generates a new table id
func generate_new_prop_id() -> int :
	if(m_props.size() == 0):
		return 0

	return m_props[m_props.size()-1].get_prop_id() + 1

# returns the properties count
func get_props_count() -> int :
	return m_props.size()

# returns the property at index or null if the index is out of bounds
func get_prop_at(idx : int) -> Object :
	if(idx < 0 || idx >= m_props.size()):
		print("ERROR: GDDBDTable::get_prop_id( " + str(idx) + " ) - index out of bounds; max properties: " + str(m_props.size()))
		return null

	return m_props[idx]

# returns a property by id or null if the id is not found
func get_prop_by_id(prop_id : int) -> Object :
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			return m_props[idx]

	print("ERROR: GDDBDTable::get_prop_by_id(" + str(prop_id) + ") - property with id not found")
	return null

# returns a property by name
func get_prop_by_name(pror_name : String) -> Object :
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_name() == pror_name):
			return m_props[idx]

	print("ERROR: GDDBDTable::get_prop_by_name(" + str(pror_name) + ") - property with name not found")
	return null

# adds a row with blank data
func add_blank_row() -> void :
	# print("GDDBTable::add_blank_row()")
	var prop_type = gddb_types.e_prop_type_bool

	for idx in range(0, m_props.size()):
		var data = load(gddb_constants.c_addon_main_path + "core/db_data.gd").new()
		data.set_prop_id(m_props[idx].get_prop_id())
		data.set_row_idx(m_rows_count)

		prop_type = m_props[idx].get_prop_type()

		if(prop_type == gddb_types.e_prop_type_bool):
			data.set_data("0")

		elif(prop_type == gddb_types.e_prop_type_int):
			if(m_props[idx].has_autoincrement()):
				data.set_data(str(m_rows_count+1))
			else:
				data.set_data("0")

		elif(prop_type == gddb_types.e_prop_type_float):
			data.set_data("0.0")

		elif(prop_type == gddb_types.e_prop_type_string):
			data.set_data("")

		elif(prop_type == gddb_types.e_prop_type_resource):
			data.set_data("res://")

		elif(prop_type >= gddb_types.e_prop_types_count):
			data.set_data(str(-1))

		m_data.push_back(data)

	m_rows_count += 1

# adds a row with data
func add_row(data_array : Array) -> void :
	if(data_array.size() != m_props.size()):
		print("ERROR: GDDBDTable::add_row( " + str(data_array) + " ) - cannot add row; properties count = " + str(m_props.size()) + " and data size = " + str(data_array.size()))
		return

	var prop_type = gddb_types.e_prop_type_bool
	var the_data = ""

	for idx in range(0, m_props.size()):
		var data = load(gddb_constants.c_addon_main_path + "core/db_data.gd").new()
		# print("adding data: [" + str(m_props[idx].get_prop_id()) + ", " + data_array[idx] + "]")
		# print("setting prop id: " + str(m_props[idx].get_prop_id()))

		data.set_prop_id(m_props[idx].get_prop_id())
		data.set_row_idx(m_rows_count)

		# ignore data if the property has autoincrement option
		if(m_props[idx].has_autoincrement()):
			data.set_data(str(m_rows_count+1))
			m_data.push_back(data)
			continue

		prop_type = m_props[idx].get_prop_type()
		the_data = data_array[idx]

		if(prop_type == gddb_types.e_prop_type_bool):
			data.set_data(str(the_data))
		elif(prop_type == gddb_types.e_prop_type_int):
			data.set_data(str(the_data))
		elif(prop_type == gddb_types.e_prop_type_float):
			data.set_data(str(the_data))
		elif(prop_type == gddb_types.e_prop_type_string):
			data.set_data(gddb_globals.handle_string(the_data))
		elif(prop_type == gddb_types.e_prop_type_resource):
			data.set_data(the_data)
		else:
			print("ERROR: data type doesn't exist - " + str(m_props[idx].get_prop_type()))

		m_data.push_back(data)

	m_rows_count += 1

# removes a row
func remove_row(row_idx : int) -> void :
	for idx in range(m_data.size()-1, 0, -1):
		if(m_data[idx].get_row_idx() == row_idx):
			m_data[idx].remove(idx)
			m_rows_count -= 1

# returns the rows count
func get_rows_count() -> int :
	return m_rows_count

# edits the data
func edit_data(prop_id : int, row_idx : int, data : String) -> void :
	# print("#1: GDDBTable::edit_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
	for idx in range(0, m_data.size()):
		# print("checking ( " + str(m_data[idx].get_row_idx()) + ", " + str(m_data[idx].get_prop_id()) + " )")
		if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
			# print("#2: GDDBTable::edit_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
			m_data[idx].set_data(data)
			return

	print("ERROR: GDDBDTable::edit_data(" + str(prop_id) + ", " + str(row_idx) + ", " + data + ") - can't find data to edit")

# edits the data
func edit_data_by_prop_name(prop_name : String, row_idx : int, data : String) -> void :
	# print("#1: GDDBTable::edit_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
	for idx in range(0, m_data.size()):
		# print("checking ( " + str(m_data[idx].get_row_idx()) + ", " + str(m_data[idx].get_prop_id()) + " )")
		var prop = get_prop_at(idx)
		if(m_data[idx].get_row_idx() == row_idx && prop.get_prop_name() == prop_name):
			# print("#2: GDDBTable::edit_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
			m_data[idx].set_data(data)
			return

	print("ERROR: GDDBDTable::edit_data_by_prop_name(" + prop_name + ", " + str(row_idx) + ", " + data + ") - can't find data to edit")

# returns data count
func get_data_size() -> int :
	return m_data.size()

# returns all data
func get_all_data() -> Array :
	return m_data

# returns the data at index
func get_data_at(idx : int) -> String :
	if(idx < 0 || idx >= m_data.size()):
		print("ERROR: GDDBDTable::get_data_at( " + str(idx) + ") - max data size: " + str(m_data.size()))
		return ""

	return m_data[idx].get_data()

# returns a dictionary containing the data at index
func get_dictionary_at(idx : int) -> Dictionary :
	var dict = {}

	if(idx < 0 || idx >= m_data.size()):
		print("ERROR: GDDBDTable::get_data_at( " + str(idx) + ") - max data size: " + str(m_data.size()))
		return dict

	var prop_idx = idx % m_props.size()
	var data_prop_name = m_props[prop_idx].get_prop_name()
	dict[data_prop_name] = m_data[idx].get_data()

	return dict

# returns the data by a property id and a row index
func get_data(prop_id : int, row_idx : int) -> String :
	for idx in range(m_data.size()-1, 0, -1):
		if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
			return m_data[idx].get_data()

	print("ERROR: GDDBDTable::get_data(" + str(prop_id) + ", " + str(row_idx) +  ")")
	return ""

# returns a dictionary containing the data by a property id and a row index
func get_dictionary(prop_id : int, row_idx : int) -> Dictionary :
	var dict = {}

	for idx in range(m_data.size()-1, 0, -1):
		if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
			var prop = get_prop_by_id(prop_id)
			var data_prop_name = prop.get_prop_name()
			dict[data_prop_name] = m_data[idx].get_data()
			return dict

	print("ERROR: GDDBDTable::get_data(" + str(prop_id) + ", " + str(row_idx) +  ")")
	return dict

# returns an array of data at row index
func get_data_at_row_idx(row_idx : int) -> Array :
	var data = []
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_row_idx() == row_idx):
			data.push_back(m_data[idx])

	if(data.size() == -1):
		print("ERROR: GDDBDTable::get_data_at_row_idx(" + str(row_idx) + ") - invalid row index")

	return data

# returns a dictionary of data at row index
func get_dictionary_at_row_idx(row_idx : int) -> Dictionary :
	var dict = {}

	var prop_idx = 0
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_row_idx() == row_idx):
			var data_prop_name = m_props[prop_idx].get_prop_name()
			dict[data_prop_name] = m_data[idx].get_data()
			prop_idx += 1

	if(dict.empty()):
		print("ERROR: GDDBDTable::get_data_at_row_idx(" + str(row_idx) + ") - invalid row index")

	return dict

# returns an array of data filtered by property id
func get_data_by_prop_id(prop_id : int, data_filter : int = gddb_types.e_data_filter_equal) -> Array :
	var data = []

	if(data_filter < gddb_types.e_data_filter_equal || data_filter >= gddb_types.e_data_filter_gequal):
		print("ERROR: cannot process filter " + str(data_filter))
		return data

	for idx in range(0, m_data.size()):
		if(data_filter == gddb_types.e_data_filter_equal):
			if(m_data[idx].get_prop_id() == prop_id):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_not_equal):
			if(m_data[idx].get_prop_id() != prop_id):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_less):
			if(m_data[idx].get_prop_id() < prop_id):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_greater):
			if(m_data[idx].get_prop_id() > prop_id):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_lequal):
			if(m_data[idx].get_prop_id() <= prop_id):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_gequal):
			if(m_data[idx].get_prop_id() >= prop_id):
				data.push_back(m_data[idx])

	if(data.size() == 0):
		print("ERROR: GDDBDTable::get_data_by_prop_id(" + str(prop_id) + ", " +  gddb_globals.get_data_filter_name(data_filter) + ") - filtered data not found")

	return data

# returns an array of data by property name
func get_data_by_prop_name(prop_name : String) -> Array :
	var prop_id = -1
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_name() == prop_name):
			prop_id = m_props[idx].get_prop_id()
			break

	if(prop_id == -1):
		print("ERROR: GDDBDTable::get_data_by_prop_name(" + prop_name + ") - property not found")
		return []

	return get_data_by_prop_id(prop_id)

# returns an array of data filtered by data
# filters "<", ">", "<=" and ">=" are working for integer and float data types
func get_data_by_data(data_value : String, data_filter : int = gddb_types.e_data_filter_equal) -> Array :
	var data = []

	if(data_filter < gddb_types.e_data_filter_equal || data_filter >= gddb_types.e_data_filter_gequal):
		print("ERROR: cannot process filter " + str(data_filter))
		return data

	for idx in range(0, m_data.size()):
		if(data_filter == gddb_types.e_data_filter_equal):
			if(m_data[idx].get_data() == data_value):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_not_equal):
			if(m_data[idx].get_data() != data_value):
				data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_less):
			if(m_props[idx].get_prop_type() < gddb_types.e_prop_type_resource):
				if(m_data[idx].get_data() < data_value):
					data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_greater):
			if(m_props[idx].get_prop_type() < gddb_types.e_prop_type_resource):
				if(m_data[idx].get_data() > data_value):
					data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_lequal):
			if(m_props[idx].get_prop_type() < gddb_types.e_prop_type_resource):
				if(m_data[idx].get_data() <= data_value):
					data.push_back(m_data[idx])

		elif(data_filter == gddb_types.e_data_filter_gequal):
			if(m_props[idx].get_prop_type() < gddb_types.e_prop_type_resource):
				if(m_data[idx].get_data() >= data_value):
					data.push_back(m_data[idx])

	if(data.size() == 0):
		print("ERROR: GDDBDTable::get_data_by_data(" + data_value + ", " + gddb_globals.get_data_filter_name(data_filter) + ") - filtered data not found")

	return data

# returns an array of data by a property name and a data value
# similar to: select * from users where user_id = 1
func get_data_by_prop_name_and_data(prop_name : String, data_value : String) -> Array :
	var the_array = []

	var prop_idx = -1
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_name() == prop_name):
			prop_idx = idx
			break

	for idx in range(0, m_rows_count):
		var row_data = get_data_at_row_idx(idx)
		# print("Comparing row: " + row_data[0].get_data() + ", " + row_data[1].get_data() + ", " + row_data[2].get_data() + ", " + row_data[3].get_data() + ", " + row_data[4].get_data())
		if(row_data[prop_idx].get_data() == data_value):
			var dict = get_dictionary_at_row_idx(idx)
			the_array.push_back(row_data)

	return the_array

# returns a dictionary of data by a property name and a data value
# similar to: select * from users where user_id = 1
func get_dictionary_by_prop_name_and_data(prop_name : String, data_value : String) -> Array :
	var the_array = []

	var prop_idx = -1
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_name() == prop_name):
			prop_idx = idx
			break

	for idx in range(0, m_rows_count):
		var row_data = get_data_at_row_idx(idx)
		# print("Comparing row: " + row_data[0].get_data() + ", " + row_data[1].get_data() + ", " + row_data[2].get_data() + ", " + row_data[3].get_data() + ", " + row_data[4].get_data())
		if(row_data[prop_idx].get_data() == data_value):
			var dict = get_dictionary_at_row_idx(idx)
			the_array.push_back(get_dictionary_at_row_idx(idx))

	return the_array

# clears the table's structure and data
func clear() -> void :
	# clear data
	clear_data()

	# clear properties
	for idx in range(0, m_props.size()):
		m_props[idx].free()
	m_props.clear()

# clears the table's data
func clear_data() -> void :
	for idx in range(0, m_data.size()):
		m_data[idx].free()
	m_data.clear()
	m_rows_count = 0

# dumps the table
func dump() -> String :
	var dump_text = "Table dump. id: " + str(m_table_id) + ", name: " + m_table_name + ", props_count: " + str(m_props.size()) + ", rows_count: " + str(m_rows_count)
	dump_text += "\n------------------------------------------------------------------------------------\nProperties:"

	for idx in range(0, m_props.size()):
		dump_text += "\n" + m_props[idx].dump()

	dump_text += "\n------------------------------------------------------------------------------------\nData:\n"

	for idx in range(0, m_rows_count):
		var tmp_text = "row_idx: " + "%" + str(gddb_globals.get_digits_count(m_rows_count)) + "d"
		dump_text += tmp_text % idx
		var row = get_data_at_row_idx(idx)
		for jdx in range(0, row.size()):
			dump_text += " | " + row[jdx].get_data()
		dump_text += "\n"

	return dump_text

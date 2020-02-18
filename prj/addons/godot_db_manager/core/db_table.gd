"""
Database Table class
"""

extends Object

var m_name = ""
var m_props = []
var m_data = []
var m_rows_count = 0

# sets the table name
func set_table_name(name: String) -> void :
	m_name = name

# gets the table name
func get_table_name() -> String :
	return m_name

# adds a property in the table structure
# prop_id must be unique
# returns true if the property is unique and can be added, otherwise false
func add_prop(prop_id : int, prop_type : int, prop_name : String) -> bool :
	# check if the property is unique by its id
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			print("ERROR: cTable::add_prop(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ") - prop_id already exists")
			return false

	# print("add_prop(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ")")
	var prop = load("res://addons/godot_db_manager/core/db_prop.gd").new()
	prop.set_prop_id(prop_id)
	prop.set_prop_type(prop_type)
	prop.set_prop_name(prop_name)
	m_props.push_back(prop)

	# adding blank data to all existing rows
	if(m_data.size() > 0):
		var new_data_array = []
		var data_idx = 0
		var row_idx = 0
		while(true):
			var data = m_data[data_idx]
			row_idx = data.get_row_idx()
			if(data.get_prop_id() + 1 == prop_id):
				new_data_array.push_back(data)
				var new_data = load("res://addons/godot_db_manager/core/db_data.gd").new()
				new_data.set_prop_id(prop_id)
				new_data.set_row_idx(row_idx)
				new_data.set_data("empty")
				new_data_array.push_back(new_data)
			else:
				new_data_array.push_back(data)
	
			data_idx += 1
			if(data_idx >= m_data.size()):
				break

		m_data.clear()
		for idx in range(0, new_data_array.size()):
			m_data.push_back(new_data_array[idx])

	return true

# edits a property in the table structure
func edit_prop(prop_id : int, prop_type : int, prop_name: String) -> void :
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			m_props[idx].set_prop_type(prop_type)
			m_props[idx].set_prop_name(prop_name)
			return
	print("ERROR: cTable::edit_prop(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ") - property not found")

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
		print("ERROR: cTable::delete_prop( " + str(prop_id) + " ) - property not found !")
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

	# recreate properties' ids
	for idx in range(0, m_props.size()):
		m_props[idx].set_prop_id(idx)

	# recreate properties' ids from data
	for idx in range(0, m_data.size()):
		var p_id = m_data[idx].get_prop_id()
		if(p_id > prop_id):
			m_data[idx].set_prop_id(p_id + 1)

# returns the properties count
func get_props_count() -> int :
	return m_props.size()

# returns the property at index or null if the index is out of bounds
func get_prop_at(idx : int) -> Object :
	if(idx < 0 || idx > m_props.size()-1):
		print("ERROR: cTable::get_prop_id( " + str(idx) + " ) - index out of bounds; max properties: " + str(m_props.size()))
		return null
	return m_props[idx]

# adds a row with blank data
func add_blank_row() -> void:
	for idx in range(0, m_props.size()):
		var data = load("res://addons/godot_db_manager/core/db_data.gd").new()
		data.set_prop_id(m_props[idx].get_prop_id())
		data.set_row_idx(m_rows_count)
		m_data.push_back(data)
	m_rows_count += 1

# adds a row with data
func add_row(data_array : Array) -> void:
	if(data_array.size() != m_props.size()):
		print("ERROR: cTable::add_row( " + str(data_array) + " ) - cannot add row; properties count = " + str(m_props.size()) + "and data size = " + str(data_array.size()))
		return
	for idx in range(0, m_props.size()):
		var data = load("res://addons/godot_db_manager/core/db_data.gd").new()
		# print("adding data: [" + str(m_props[idx].get_prop_id()) + ", " + data_array[idx] + "]")
		# print("setting prop id: " + str(m_props[idx].get_prop_id()))
		data.set_prop_id(m_props[idx].get_prop_id())
		data.set_row_idx(m_rows_count)
		if(m_props[idx].get_prop_type() == gd_types.e_prop_type_bool):
			data.set_data(str(data_array[idx]))
		elif(m_props[idx].get_prop_type() == gd_types.e_prop_type_int):
			data.set_data(str(data_array[idx]))
		elif(m_props[idx].get_prop_type() == gd_types.e_prop_type_float):
			data.set_data(str(data_array[idx]))
		elif(m_props[idx].get_prop_type() == gd_types.e_prop_type_string):
			data.set_data(data_array[idx])
		m_data.push_back(data)
	m_rows_count += 1

# removes a row
func remove_row(row_idx : int) -> void:
	for idx in range(m_data.size()-1, 0, -1):
		if(m_data[idx].get_row_idx() == row_idx):
			m_data[idx].remove(idx)
			m_rows_count -= 1

# returns the rows count
func get_rows_count() -> int:
	return m_rows_count

# edits the data
func edit_data(prop_id : int, row_idx : int, data : String) -> void:
	# print("#1: cTable::edit_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
	for idx in range(0, m_data.size()):
		# print("checking ( " + str(m_data[idx].get_row_idx()) + ", " + str(m_data[idx].get_prop_id()) + " )")
		if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
			# print("#2: cTable::edit_data( " + str(prop_id) + ", " + str(row_idx) + ", " + data + " )")
			m_data[idx].set_data(data)
			return
	print("ERROR: cTable::edit_data(" + str(prop_id) + ", " + str(row_idx) + ", " + data + ") - can't find data to edit")

# returns data count
func get_data_size() -> int:
	return m_data.size()

# returns the data from at index
func get_data_at(idx : int) -> String:
	if(idx < 0 || idx >= m_data.size()):
		print("ERROR: cTable::get_data_at( " + str(idx) + ") - max data size: " + str(m_data.size()))
		return ""
	return m_data[idx].get_data()

# returns the data from an index
func get_data(prop_id : int, row_idx : int) -> String:
	for idx in range(m_data.size()-1, 0, -1):
		if(m_data[idx].get_row_idx() == row_idx && m_data[idx].get_prop_id() == prop_id):
			return m_data[idx].get_data()
	print("ERROR: cTable::get_data(" + str(prop_id) + ", " + str(row_idx) +  ")")
	return ""

# returns an array of data by property id
func get_data_by_prop_id(prop_id : int) -> Array:
	var data = []
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_prop_id() == prop_id):
			data.push_back(m_data[idx])
	if(data.size() == 0):
		print("ERROR: cTable::get_data_by_prop_id(" + str(prop_id) + ") - property not found")
	return data

# returns an array of data by property name
func get_data_by_prop_name(prop_name : String) -> Array:
	var prop_id = -1
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_name() == prop_name):
			prop_id = m_props[idx].get_prop_id()
			break
	if(prop_id == -1):
		print("ERROR: cTable::get_data_by_prop_name(" + prop_name + ") - property not found")
		return []
	return get_data_by_prop_id(prop_id)

func get_data_by_row_idx(row_idx):
	var data = []
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_row_idx() == row_idx):
			data.push_back(m_data[idx])
	if(data.size() == -1):
		print("ERROR: cTable::get_data_by_row_idx(" + str(row_idx) + ")")
	return data

# returns an array of data by a property name and a data value
# similar to: select * from users where user_id = 1
func get_row_by_data(prop_name : String, data_value : String) -> Array:
	var prop_id = -1
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_name() == prop_name):
			prop_id = m_props[idx].get_prop_id()
			break
	var row = []
	if(prop_id == -1):
		print("ERROR: cTable::get_row_by_data(" + prop_name + ", " + str(data_value) + ") - property not found")
		return row
	var row_idx = -1
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_prop_id() == prop_id && m_data[idx].get_data() == data_value):
			row_idx = m_data[idx].get_row_idx()
			break
	if(row_idx == -1):
		print("ERROR: cTable::get_row_by_data(" + prop_name + ", " + str(data_value) + ") - data not found")
		return row
	for idx in range(0, m_data.size()):
		if(m_data[idx].get_row_idx() == row_idx):
			row.push_back(m_data[idx])
	if(row.size() == -1):
		print("ERROR: cTable::get_row_by_data(" + prop_name + ", " + str(data_value) + ") - data not found")
	return row

# clears the table's structure and data
func clear() -> void:
	# clear data
	for idx in range(0, m_data.size()):
		m_data[idx].free()
	m_data.clear()

	# clear properties
	for idx in range(0, m_props.size()):
		m_props[idx].free()
	m_props.clear()

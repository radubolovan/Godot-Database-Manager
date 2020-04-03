"""
GDDBProperty class
"""

class_name GDDBProperty

extends Object

var m_prop_id : int  = -1
var m_prop_type : int = gddb_types.e_prop_type_int
var m_custom_type : String = ""
var m_prop_name : String = ""

var m_autoincrement : bool = false

# sets the property id
func set_prop_id(prop_id : int) -> void :
	m_prop_id = prop_id

# returns the property id
func get_prop_id() -> int :
	return m_prop_id

# sets the property type
func set_prop_type(prop_type : int) -> void :
	m_prop_type = prop_type

# returns the property type
func get_prop_type() -> int :
	return m_prop_type

# sets the custom type
func set_prop_custom_type(prop_type : String) -> void :
	m_custom_type = prop_type

# returns the custom type
func get_prop_custom_type() -> String :
	return m_custom_type

# sets the property name
func set_prop_name(prop_name : String) -> void :
	m_prop_name = prop_name

# returns the property name
func get_prop_name() -> String :
	return m_prop_name

# enables or disables the auto increment property
func enable_autoincrement(enable : bool) -> void :
	if(enable && m_prop_type != gddb_types.e_prop_type_int):
		if(m_prop_type < gddb_types.e_prop_types_count):
			print("ERROR: autoincrement option can be set to integer data type only. Type is: " + gddb_types.get_data_name(m_prop_type))
		else:
			print("ERROR: autoincrement option can be set to integer data type only. Custom type is: " + m_custom_type)
		return
	m_autoincrement = enable

# returns if the property has auto increment
func has_autoincrement() -> bool :
	return m_autoincrement

# dumps the property
func dump() -> String :
	var dump_text = "prop_id: " + str(m_prop_id) + ", prop_name: " + m_prop_name

	if(m_prop_type <= gddb_types.e_prop_type_resource):
		dump_text += ", prop_type: " + gddb_globals.get_data_name(m_prop_type)
	else:
		dump_text += ", custom_prop_type: " + m_custom_type

	return dump_text

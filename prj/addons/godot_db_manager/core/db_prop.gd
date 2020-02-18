"""
DB Property class
"""

extends Object

var m_id : int  = -1
var m_type : int = gd_types.e_prop_type_int
var m_name : String = ""

# sets the property id
func set_prop_id(id : int) -> void :
	m_id = id

# returns the property id
func get_prop_id() -> int :
	return m_id

# sets the property type
func set_prop_type(type) -> void :
	m_type = type

# returns the property type
func get_prop_type() -> int :
	return m_type

# sets the property name
func set_prop_name(name : String) -> void:
	m_name = name

# returns the property name
func get_prop_name() -> String:
	return m_name

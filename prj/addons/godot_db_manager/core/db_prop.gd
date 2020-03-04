"""
GDDBProperty class
"""

class_name GDDBProperty

extends Object

var m_id : int  = -1
var m_type : int = db_types.e_prop_type_int
var m_custom_type : String = ""
var m_name : String = ""

# sets the property id
func set_prop_id(id : int) -> void :
	m_id = id

# returns the property id
func get_prop_id() -> int :
	return m_id

# sets the property type
func set_prop_type(type : int) -> void :
	m_type = type

# sets the custom type
func set_prop_custom_type(type : String) -> void:
	m_custom_type = type

# returns the custom type
func get_prop_custom_type() -> String:
	return m_custom_type

# returns the property type
func get_prop_type() -> int :
	return m_type

# sets the property name
func set_prop_name(name : String) -> void:
	m_name = name

# returns the property name
func get_prop_name() -> String:
	return m_name

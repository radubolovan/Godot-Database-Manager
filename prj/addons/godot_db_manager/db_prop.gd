extends Node

enum {
	e_prop_type_int = 0,
	e_prop_type_string
}

var m_id
var m_type
var m_name

func set_prop_id(id):
	m_id = id

func get_prop_id():
	return m_id

func set_prop_type(type):
	m_type = type

func get_prop_type():
	return m_type

func set_prop_name(name):
	m_name = name

func get_prop_name():
	return m_name

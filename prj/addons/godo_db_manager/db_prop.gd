extends Node

enum {
	e_prop_type_int = 0,
	e_prop_type_string
}

var m_id
var m_type
var m_name

func set_id(id):
	m_id = id

func get_id():
	return m_id

func set_type(type):
	m_type = type

func get_type():
	return m_type

func set_name(name):
	m_name = name

func get_name():
	return m_name

extends Node

var m_prop_id = -1
var m_row_idx = -1
var m_data = ""

func set_prop_id(id):
	m_prop_id = id

func get_prop_id():
	return m_prop_id

func set_row_idx(idx):
	m_row_idx = idx

func get_row_idx():
	return m_row_idx

func set_data(data):
	m_data = data

func get_data():
	return m_data

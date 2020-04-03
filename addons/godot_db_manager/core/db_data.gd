"""
GDDBData class
"""

class_name GDDBData

extends Object

var m_prop_id : int = -1
var m_row_idx : int  = -1
var m_data : String = ""

# sets the property id
func set_prop_id(prop_id : int) -> void :
	m_prop_id = prop_id

# returns the property id
func get_prop_id() -> int :
	return m_prop_id

# sets the row index
func set_row_idx(row_idx : int) -> void :
	m_row_idx = row_idx

# returns the row index
func get_row_idx() -> int :
	return m_row_idx

# sets the data
func set_data(data : String) -> void :
	m_data = data

# returns the data
func get_data() -> String :
	return m_data

# dumps the data
func dump() -> String :
	var dump_text = "prop_id: " + str(m_prop_id) + ", row_idx: " + str(m_row_idx) + ", data: " + m_data
	return dump_text

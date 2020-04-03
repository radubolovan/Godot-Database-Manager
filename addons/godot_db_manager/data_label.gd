"""
class GDDBDataLabel
"""

class_name GDDBDataLabel

tool
extends Label

var m_prop_id : int = gddb_constants.c_invalid_id
var m_prop_type : int = gddb_constants.c_invalid_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_custom_minimum_size(Vector2(150.0, 24.0))

# sets property id
func set_prop_id(id : int) -> void:
	m_prop_id = id

# returns property id
func get_prop_id() -> int:
	return m_prop_id

# sets property type
func set_prop_type(prop_type : int) -> void :
	m_prop_type = prop_type

# returns property type
func get_prop_type() -> int :
	return m_prop_type

tool
extends Label

var m_prop_id = -1

func _ready():
	set_custom_minimum_size(Vector2(100.0, 24.0))

func set_prop_id(id):
	m_prop_id = id

func get_prop_id():
	return m_prop_id

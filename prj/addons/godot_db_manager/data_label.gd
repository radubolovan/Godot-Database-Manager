tool
extends Label

var m_prop_id : int = -1

func _ready() -> void:
	set_custom_minimum_size(Vector2(100.0, 24.0))

func set_prop_id(id : int) -> void:
	m_prop_id = id

func get_prop_id() -> int:
	return m_prop_id

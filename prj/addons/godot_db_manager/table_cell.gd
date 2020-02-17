tool
extends LineEdit

signal edit_data

var m_prop_id : int = -1
var m_row_idx : int = -1

func _ready() -> void:
	connect("text_changed", self, "on_text_changed")

func _exit_tree() -> void:
	disconnect("text_changed", self, "on_text_changed")

# sets the property id
func set_prop_id(id : int) -> void:
	m_prop_id = id

# returns the property id
func get_prop_id() -> int:
	return m_prop_id

# sets the row index
func set_row_idx(idx : int) -> void:
	m_row_idx = idx

# returns the property index
func get_row_idx() -> int:
	return m_row_idx

# called when edit the data
func on_text_changed(new_text : String) -> void:
	emit_signal("edit_data", m_prop_id, m_row_idx, new_text)

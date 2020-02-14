tool
extends LineEdit

signal update_cell_data

var m_prop_id = -1
var m_row_idx = -1

func _ready():
	connect("text_changed", self, "on_text_changed")

func _exit_tree():
	disconnect("text_changed", self, "on_text_changed")

func set_prop_id(id):
	m_prop_id = id

func get_prop_id():
	return m_prop_id

func set_row_idx(idx):
	m_row_idx = idx

func get_row_idx():
	return m_row_idx

func on_text_changed(new_text):
	emit_signal("update_cell_data", m_prop_id, m_row_idx, new_text)

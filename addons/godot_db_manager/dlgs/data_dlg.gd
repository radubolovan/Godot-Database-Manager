"""
class GDDBDataPanel
"""

class_name GDDBDataPanel

tool
extends PopupPanel

signal select_data

var m_prop_id = gddb_constants.c_invalid_id
var m_row_idx = gddb_constants.c_invalid_id

var m_table = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("about_to_show", self, "on_about_to_show")
	$ItemList.connect("item_selected", self, "on_item_selected")

# sets property id
func set_prop_id(prop_id : int) -> void :
	m_prop_id = prop_id

# returns property id
func get_prop_id() -> int :
	return m_prop_id

# sets row index
func set_row_idx(row_idx : int) -> void :
	m_row_idx = row_idx

# returns row index
func get_row_idx() -> int :
	return m_row_idx

# sets the table from the database
func set_table(table) -> void:
	m_table = table

# returns the table from the database
func get_table() -> Object:
	return m_table

# called when the popup is about to show
func on_about_to_show() -> void :
	$ItemList.clear()
	$ItemList.add_item("None")
	for idx in range(0, m_table.get_rows_count()):
		var option = gddb_globals.get_json_from_row(m_table, idx)
		$ItemList.add_item(option)

# called when an item is selected
func on_item_selected(idx : int) -> void:
	# the first index is ""
	if(idx == 0):
		emit_signal("select_data", m_prop_id, m_row_idx, -1, "{}" )
	else:
		emit_signal("select_data", m_prop_id, m_row_idx, idx-1, $ItemList.get_item_text(idx) )
	hide()

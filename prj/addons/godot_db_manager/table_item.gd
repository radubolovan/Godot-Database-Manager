"""
class GDDBTableItem
"""

class_name GDDBTableItem

tool
extends Control

signal select_item
signal edit_table
signal delete_table

var m_table_id = gddb_constants.c_invalid_id
var m_table_name = ""

var m_is_selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$select_btn.connect("pressed", self, "on_select_btn_pressed")
	$elems/edit_table_btn.connect("pressed", self, "on_edit_table_btn_pressed")
	$elems/delete_table_btn.connect("pressed", self, "on_delete_table_btn_pressed")
	$select.hide()

# sets the table id
func set_table_id(id : int) -> void:
	m_table_id = id

# returns the table id
func get_table_id() -> int:
	return m_table_id

func set_selected(select : bool) -> void :
	m_is_selected = select
	if(m_is_selected):
		$select.show()
	else:
		$select.hide()

func is_selected():
	return m_is_selected

# sets the table name
func set_table_name(name : String) -> void:
	# print("GDDBTableItem::set_table_name(" + name + ")")
	m_table_name = name
	$elems/table_name.set_text(m_table_name)

# returns the table name
func get_table_name() -> String:
	return m_table_name

# called when the user presses the edit_table button
func on_edit_table_btn_pressed():
	# print("GDDBTableItem::on_edit_table_btn_pressed")
	emit_signal("edit_table", m_table_id, m_table_name)

# called when the user presses the delete_table button
func on_delete_table_btn_pressed():
	# print("GDDBTableItem::on_delete_table_btn_pressed")
	emit_signal("delete_table", m_table_id)

# called when select_btn is pressed
func on_select_btn_pressed() -> void:
	# print("GDDBTableItem::on_select_btn_pressed()")
	emit_signal("select_item", m_table_id)

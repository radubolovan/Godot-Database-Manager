"""
class GDDBTablesList
"""

class_name GDDBTablesList

tool
extends Control

signal resize_tables_list

signal add_table
signal edit_table_name
signal delete_table
signal select_table

var m_tables = []

var m_mouse_pos_pressed : Vector2 = Vector2()
var m_mouse_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_mouse_pos_pressed = Vector2()
	m_mouse_pressed = false

	$tables_header.connect("add_table", self, "on_add_table")

# called when the node gets an input
func _input(event : InputEvent) -> void :
	if(!gddb_globals.is_interface_active()):
		return

	var evLocal = $resize_ctrl.make_input_local(event)

	if event is InputEventMouseButton :
		if(event.button_index == BUTTON_LEFT):
			if(event.pressed):
				var rect = Rect2(Vector2(0, 0), $resize_ctrl.get_size())
				var inside = rect.has_point(evLocal.position)
				if(inside):
					m_mouse_pressed = true
					m_mouse_pos_pressed = evLocal.position
			else:
				m_mouse_pressed = false

	elif event is InputEventMouseMotion :
		if(m_mouse_pressed):
			var diff_x = evLocal.position.x - m_mouse_pos_pressed.x
			emit_signal("resize_tables_list", diff_x)

# custom resizing the tables list
func resize_content(size : Vector2) -> void :
	set_size(size)

	# I have no idea why I need to do this; this should be done automatically
	var content_size = $tables_container/tables.get_size()
	content_size.x = size.x
	$tables_container/tables.set_custom_minimum_size(content_size)

# Called when the user presses the "add_table" button from the tables_list/header
func on_add_table() -> void :
	# print("GDDBTablesList::on_add_table()")
	emit_signal("add_table")

# creates a table
func create_table(db_table : Object, select_table : bool = true) -> void:
	# print("GDDBTablesList::create_table(" + str(db_table) + ")")
	var table = load(gddb_constants.c_addon_main_path + "table_item.tscn").instance()
	var table_id = db_table.get_table_id()
	table.set_table_id(table_id)
	table.set_table_name(db_table.get_table_name())
	table.connect("select_item", self, "on_select_item")
	table.connect("edit_table", self, "on_edit_table_name")
	table.connect("delete_table", self, "on_delete_table")
	m_tables.push_back(table)
	$tables_container/tables.add_child(table)
	if(select_table):
		select_item_by_id(table_id)

# Called when the user presses the "edit_table" button from the tables_list/table
func on_edit_table_name(table_id : int, table_name : String) -> void:
	# print("GDDBTablesList::on_edit_table_name(" + str(table_id) + ", " + table_name + ")")
	emit_signal("edit_table_name", table_id, table_name)

# Called when the user presses the "delete_table" button from the tables_list/table
func on_delete_table(table_id : int) -> void:
	# print("GDDBTablesList::on_delete_table(" + str(table_id) + ")")
	emit_signal("delete_table", table_id)

# edits the table name
func edit_table_name(table_id: int, table_name : String) -> void:
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			m_tables[idx].set_table_name(table_name)
			break

# deletes a table from the list
func delete_table(table_id : int) -> void:
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			$tables_container/tables.remove_child(m_tables[idx])
			m_tables.remove(idx)
			break

# called when the user presses an item
func on_select_item(table_id : int) -> void:
	# print("GDDBTablesList::on_select_item(" + str(table_id) + ")")
	select_item_by_id(table_id)
	emit_signal("select_table", table_id)

# select an item by index
func select_item_at(table_idx : int) -> void:
	for idx in range(0, m_tables.size()):
		m_tables[idx].set_selected(idx == table_idx)

# select an item by id
func select_item_by_id(table_id : int) -> void:
	# print("GDDBTablesList::select_item_by_id(" + str(table_id) + ")")
	for idx in range(0, m_tables.size()):
		m_tables[idx].set_selected(m_tables[idx].get_table_id() == table_id)

# returns the selected element
func get_selected_item():
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].is_selected()):
			return m_tables[idx]
	print("ERROR: GDDBTablesList::get_selected_item() - there is no selected element")
	return null

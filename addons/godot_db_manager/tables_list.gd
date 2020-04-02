"""
class GDDBTablesList
"""

class_name GDDBTablesList

tool
extends Control

signal add_table
signal edit_table_name
signal delete_table
signal select_table

var m_tables = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$v_align/tables_header.connect("add_table", self, "on_add_table")

# Called when the user presses the "add_table" button from the tables_list/header
func on_add_table() -> void:
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
	$v_align/tables_container/tables.add_child(table)
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
			$v_align/tables_container/tables.remove_child(m_tables[idx])
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

tool
extends Control

signal add_table
signal edit_table_name
signal delete_table

var m_tables = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$tables_header.connect("add_table", self, "on_add_table")

# Called when the user presses the "add_table" button from the tables_list/header
func on_add_table() -> void:
	emit_signal("add_table")

# creates a table
func create_table(db_table) -> void:
	var table = load(g_constants.c_addon_main_path + "table_item.tscn").instance()
	table.set_table_id(db_table.get_table_id())
	table.set_table_name(db_table.get_table_name())
	table.connect("edit_table", self, "on_edit_table_name")
	table.connect("delete_table", self, "on_delete_table")
	m_tables.push_back(table)
	$tables.add_child(table)

# Called when the user presses the "edit_table" button from the tables_list/table
func on_edit_table_name(table_id : int, table_name : String) -> void:
	print("cTableList::on_edit_table_name(" + str(table_id) + ", " + table_name + ")")
	emit_signal("edit_table_name", table_id, table_name)

# Called when the user presses the "delete_table" button from the tables_list/table
func on_delete_table(table_id : int) -> void:
	emit_signal("delete_table", table_id)

# edits the table name
func edit_table_name(table_id: int, table_name : String) -> void:
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_id() == table_id):
			m_tables[idx].set_table_name(table_name)
			break

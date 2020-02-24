tool
extends Control

signal add_table
signal edit_table_name
signal delete_table

var m_tables = []

func _ready():
	$tables_header.connect("add_table", self, "on_add_table")

func on_add_table():
	emit_signal("add_table")
	"""
	var table = load(g_constants.c_addon_main_path + "table_item.tscn").instance()
	var table_name = "Table_" + str(m_tables.size() + 1)
	table.set_table_name(table_name)
	table.connect("edit_table", self, "")
	table.connect("edit_table", self, "")
	m_tables.push_back(table)
	$tables.add_child(table)
	"""
	
func on_edit_table_name(name):
	var table = get_table_by_name(name)
	if(null == table):
		return
	# emit_signal("edit_table_name", )

func on_delete_table(table_name):
	var table = get_table_by_name(name)
	if(null == table):
		return

func get_table_by_name(name):
	for idx in range(0, m_tables.size()):
		if(m_tables[idx].get_table_name() == name):
			return m_tables[idx]
	return null

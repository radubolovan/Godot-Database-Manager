tool
extends Control

signal edit_table
signal delete_table

var m_table_id = g_constants.c_invalid_id
var m_table_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$elems/edit_table_btn.connect("pressed", self, "on_edit_table_btn_pressed")
	$elems/delete_table_btn.connect("pressed", self, "on_delete_table_btn_pressed")

# sets the table id
func set_table_id(id : int) -> void:
	m_table_id = id

# returns the table id
func get_table_id() -> int:
	return m_table_id

# sets the table name
func set_table_name(name : String) -> void:
	# print("cTableItem::set_table_name(" + name + ")")
	m_table_name = name
	$elems/table_name.set_text(m_table_name)

# returns the table name
func get_table_name() -> String:
	return m_table_name

# called when the user presses the edit_table button
func on_edit_table_btn_pressed():
	print("cTableItem::on_edit_table_btn_pressed")
	emit_signal("edit_table", m_table_id, m_table_name)

# called when the user presses the delete_table button
func on_delete_table_btn_pressed():
	print("cTableItem::on_delete_table_btn_pressed")
	emit_signal("delete_table", m_table_id)

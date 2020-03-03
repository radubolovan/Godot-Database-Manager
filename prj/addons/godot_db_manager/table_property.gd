"""
class GDDBTableProperty
"""

class_name GDDBTableProperty

tool
extends Control

signal delete_property
signal edit_property

var m_id : int = -1
var m_type : int = 0
var m_name : String = ""

var m_parent_table = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$align/prop_name.connect("text_changed", self, "on_name_changed")

	$align/prop_type.remove_all_options()
	for idx in range(0, db_types.e_data_types_count):
		$align/prop_type.add_option(db_types.e_prop_type_bool + idx, db_types.get_data_name(idx))
	$align/prop_type.set_selected_option(0)

	$align/prop_type.connect("about_to_show", self, "on_about_to_show")
	$align/prop_type.connect("option_selected", self, "on_type_changed")

	$align/close_button.connect("pressed", self, "on_delete_button_pressed")

# setup property
func setup(id : int, type : int, name : String) -> void:
	# print("GDDBTableProperty::setup(" + str(id) + ", " + db_types.get_data_name(type) + ", " + name + ")")
	set_prop_id(id)
	set_prop_type(type)
	set_prop_name(name)

# sets parent table
func set_parent_table(table):
	m_parent_table = table

# sets proprty id
func set_prop_id(id : int) -> void:
	m_id = id
	$align/prop_id.set_text(str(m_id))

# returns property id
func get_prop_id() -> int:
	return m_id

# sets property type
func set_prop_type(type : int) -> void:
	# print("GDDBTableProperty::set_prop_type(" + db_types.get_data_name(type) + ")")
	m_type = type
	$align/prop_type.set_selected_option(m_type)

# returns property type
func get_prop_type() -> int:
	return m_type

# sets property name
func set_prop_name(name : String) -> void:
	m_name = name
	$align/prop_name.set_text(m_name)

# returns property name
func get_prop_name() -> String:
	return m_name

# called everytime the name of the property is changed
func on_name_changed(new_text : String) -> void:
	m_name = new_text
	emit_signal("edit_property", m_id, m_type, m_name)

# called when the popup from option button is about to be shown
func on_about_to_show():
	var selected_idx = $align/prop_type.get_current_option()
	# print("GDDBTableProperty::on_about_to_show() - " + str(selected_idx))

	$align/prop_type.remove_all_options()
	for idx in range(0, db_types.e_data_types_count):
		$align/prop_type.add_option(db_types.e_prop_type_bool + idx, db_types.get_data_name(idx))
	if(null != m_parent_table):
		var db = m_parent_table.get_parent_database()
		for idx in range(0, db.get_tables_count()):
			var table = db.get_table_at(idx)
			if(table == m_parent_table):
				continue
			$align/prop_type.add_option(db_types.e_data_types_count + table.get_table_id(), table.get_table_name())
	$align/prop_type.set_selected_option(selected_idx)

# called everytime the type of the property is changed
func on_type_changed(option_id : int) -> void:
	"""
	if(option_id >= db_types.e_data_types_count):
		print("GDDBTableProperty::on_type_changed(" + str(db_types.e_data_types_count + option_id) + ")")
	else:
		print("GDDBTableProperty::on_type_changed(" + db_types.get_data_name(option_id) + ")")
	"""
	m_type = option_id
	emit_signal("edit_property", m_id, m_type, m_name)

# called when the delete property button is pressed
func on_delete_button_pressed() -> void:
	emit_signal("delete_property", m_id)

"""
class GDDBTableProperty
"""

class_name GDDBTableProperty

tool
extends Control

signal delete_property
signal edit_property
signal enable_autoincrement

var m_prop_id : int = -1
var m_prop_type : int = 0
var m_prop_name : String = ""

var m_parent_table = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$align/prop_name.connect("text_changed", self, "on_name_changed")

	$align/prop_type.clear()
	for idx in range(0, gddb_types.e_prop_types_count):
		$align/prop_type.add_item(gddb_globals.get_data_name(idx), gddb_types.e_prop_type_bool + idx)
	$align/prop_type.select(0)

	$align/prop_type.get_popup().connect("about_to_show", self, "on_about_to_show")
	$align/prop_type.connect("item_selected", self, "on_type_changed")

	$align/delete_button.connect("pressed", self, "on_delete_button_pressed")

	$align/autoincrement_btn.hide()
	$align/autoincrement_btn.connect("toggled", self, "on_set_autoincrement")

# setup property
func setup(prop_id : int, prop_type : int, prop_name : String) -> void:
	"""
	if(prop_type < gddb_types.e_prop_types_count):
		print("GDDBTableProperty::setup(" + str(prop_id) + ", " + gddb_globals.get_data_name(prop_type) + ", " + prop_name + ")")
	else:
		var db = m_parent_table.get_parent_database()
		var table = db.get_table_by_id(prop_type - gddb_types.e_prop_types_count)
		print("GDDBTableProperty::setup(" + str(prop_id) + ", " + table.get_table_name() + ", " + prop_name + ")")
	#"""
	set_prop_id(prop_id)
	set_prop_type(prop_type)
	set_prop_name(prop_name)

# sets parent table
func set_parent_table(table):
	#print("GDDBTableProperty::set_parent_table(" + str(table) + ")")
	m_parent_table = table
	var db = m_parent_table.get_parent_database()
	for idx in range(0, db.get_tables_count()):
		var tbl = db.get_table_at(idx)
		if(tbl == m_parent_table):
			continue
		$align/prop_type.add_item(tbl.get_table_name(), gddb_types.e_prop_types_count + tbl.get_table_id())

# sets proprty id
func set_prop_id(prop_id : int) -> void:
	# print("GDDBTableProperty::set_prop_id(" + str(prop_id) + ")")
	m_prop_id = prop_id
	$align/prop_id.set_text(str(m_prop_id))

# returns property id
func get_prop_id() -> int:
	return m_prop_id

# sets property type
func set_prop_type(prop_type : int) -> void:
	"""
	print("GDDBTableProperty::set_prop_type(" + str(prop_type) + ")")
	if(prop_type < gddb_types.e_prop_types_count):
		print("GDDBTableProperty::set_prop_type(" + gddb_globals.get_data_name(prop_type) + ")")
	else:
		var db = m_parent_table.get_parent_database()
		var table = db.get_table_by_id(prop_type - gddb_types.e_prop_types_count)
		print("GDDBTableProperty::set_prop_type(" + table.get_table_name() + ")")
	#"""
	#if(prop_type >= gddb_types.e_prop_types_count):
	#	print("GDDBTableProperty::set_prop_type(" + str(prop_type) + ")")
	m_prop_type = prop_type
	select_current_prop()

	if(m_prop_type == gddb_types.e_prop_type_int):
		$align/autoincrement_btn.show()
		var prop = m_parent_table.get_prop_by_id(m_prop_id)
		if(prop.has_autoincrement()):
			$align/autoincrement_btn.set_pressed(true)
	else:
		$align/autoincrement_btn.hide()

# selects current property
func select_current_prop() -> void:
	if(m_prop_type < gddb_types.e_prop_types_count):
		$align/prop_type.select(m_prop_type)

# links property type to other tables
func link():
	# print("GDDBTableProperty::link()")
	refill_list()
	if(m_prop_type >= gddb_types.e_prop_types_count):
		"""
		print("m_prop_id : " + str(m_prop_id))
		print("m_prop_type : " + str(m_prop_type))
		print("m_prop_name : " + m_prop_name)
		"""
		set_selection_by_id(m_prop_type)
	else:
		$align/prop_type.select(m_prop_type)

# returns property type
func get_prop_type() -> int:
	return m_prop_type

# sets property name
func set_prop_name(prop_name : String) -> void:
	# print("GDDBTableProperty::set_prop_name(" + prop_name + ")")
	m_prop_name = prop_name
	$align/prop_name.set_text(m_prop_name)

# returns property name
func get_prop_name() -> String:
	return m_prop_name

# called everytime the name of the property is changed
func on_name_changed(new_text : String) -> void:
	m_prop_name = new_text
	emit_signal("edit_property", m_prop_id, m_prop_type, m_prop_name)

# called when the popup from option button is about to be shown
func on_about_to_show():
	var selected_id = $align/prop_type.get_selected_id()
	# print("GDDBTableProperty::on_about_to_show() - " + str(selected_id))

	refill_list()
	set_selection_by_id(selected_id)

# refills the list
func refill_list() -> void :
	$align/prop_type.clear()
	for idx in range(0, gddb_types.e_prop_types_count):
		$align/prop_type.add_item(gddb_globals.get_data_name(idx), gddb_types.e_prop_type_bool + idx)

	if(null != m_parent_table):
		var db = m_parent_table.get_parent_database()
		for idx in range(0, db.get_tables_count()):
			var table = db.get_table_at(idx)
			if(table == m_parent_table):
				continue
			"""
			print("GDDBTableProperty::refill_list - Add:")
			print("table id: " + str(table.get_table_id()))
			print("table name: " + table.get_table_name())
			#"""
			# print("GDDBTableProperty::prop_type.add_item(" + table.get_table_name() + ", " + str(gddb_types.e_prop_types_count + table.get_table_id()) + ")" )
			$align/prop_type.add_item(table.get_table_name(), gddb_types.e_prop_types_count + table.get_table_id())
	# $align/prop_type.select(selected_idx)

# sets selection
func set_selection_by_id(selected_id : int) -> void :
	# print("GDDBTableProperty::set_selection_by_id(" + str(selected_id) + ")")
	for idx in range(0, $align/prop_type.get_item_count()):
		if($align/prop_type.get_item_id(idx) == selected_id):
			$align/prop_type.select(idx)
			break

func on_set_autoincrement(enable : bool) -> void:
	# print("GDDBTableProperty::on_set_autoincrement(" + str(enable) + ") - " + str(m_prop_id))
	emit_signal("enable_autoincrement", m_prop_id, enable)

# called everytime the type of the property is changed
func on_type_changed(option_idx : int) -> void:
	var option_id = $align/prop_type.get_item_id(option_idx)
	"""
	print("GDDBTableProperty::on_type_changed(" + str(option_idx) + ")")
	print("option_id = " + str(option_id))
	if(option_id >= gddb_types.e_prop_types_count):
		print("GDDBTableProperty::on_type_changed(" + str(option_id) + ")")
	else:
		print("GDDBTableProperty::on_type_changed(" + gddb_globals.get_data_name(option_id) + ")")
	#"""
	m_prop_type = option_id
	$align/autoincrement_btn.set_pressed(false)
	if(m_prop_type == gddb_types.e_prop_type_int):
		$align/autoincrement_btn.show()
	else:
		$align/autoincrement_btn.hide()
	emit_signal("edit_property", m_prop_id, m_prop_type, m_prop_name)

# called when the delete property button is pressed
func on_delete_button_pressed() -> void:
	emit_signal("delete_property", m_prop_id)

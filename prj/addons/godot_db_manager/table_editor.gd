"""
class GDDBTableEditor
"""

class_name GDDBTableEditor

tool
extends Control

signal new_data_row
signal edit_data

var m_table = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$tabs/structure/new_property_btn.connect("pressed", self, "on_new_property_btn_pressed")
	$tabs/data/data_holder/btns/add_data_btn.connect("pressed", self, "on_add_row_data_btn_pressed")
	$tabs/data/data_holder/btns/add_data_btn.set_disabled(true)

# called when the new_property button is pressed
func on_new_property_btn_pressed() -> void:
	# print("GDDBTableEditor::on_new_property_btn_pressed()")
	if(null == m_table):
		print("ERROR: GDDBTableEditor::on_new_property_btn_pressed() - m_table is null")
		return
	var prop_idx = m_table.get_props_count()
	var prop_type = db_types.e_prop_type_bool
	var prop_name = "Property_" + str(prop_idx+1)
	var prop_id = m_table.add_prop(prop_type, prop_name)
	add_prop_to_structure(prop_id, prop_type, prop_name)
	add_prop_to_data(prop_id, prop_name)

	# enable add data btn
	$tabs/data/data_holder/btns/add_data_btn.set_disabled(false)

func add_prop_to_structure(prop_id : int, prop_type : int, prop_name : String) -> void:
	# print("GDDBTableEditor::add_prop_to_structure(" + str(prop_id) + ", " + db_types.get_data_name(prop_type) + ", " + prop_name + ")")
	var prop = load(g_constants.c_addon_main_path + "table_property.tscn").instance()
	$tabs/structure/properties.add_child(prop)
	prop.setup(prop_id, prop_type, prop_name)
	prop.connect("edit_property", self, "on_edit_property")
	prop.connect("delete_property", self, "on_delete_property")

func add_prop_to_data(prop_id : int, prop_name : String):
	var prop = load(g_constants.c_addon_main_path + "data_label.tscn").instance()
	$tabs/data/data_holder/data_header.add_child(prop)
	prop.set_prop_id(prop_id)
	prop.set_text(prop_name)

	# add property to the existing rows
	for idx in range(0, $tabs/data/data_holder/data_container.get_child_count()):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		var cell = load(g_constants.c_addon_main_path + "table_cell.tscn").instance()
		cell.set_prop_id(prop_id)
		cell.set_row_idx(idx)
		cell.set_text("")
		cell.connect("edit_data", self, "on_edit_data")
		row.add_child(cell)

# called when the add data button is pressed
func on_add_row_data_btn_pressed() -> void:
	# print("GDDBTableEditor::on_add_row_data_btn_pressed")
	# add blank row in the table
	var row_idx = m_table.get_rows_count()
	m_table.add_blank_row()

	# add row in the interface
	var row = HBoxContainer.new()
	$tabs/data/data_holder/data_container.add_child(row)
	for idx in range(0, $tabs/structure/properties.get_child_count()):
		var cell = load(g_constants.c_addon_main_path + "table_cell.tscn").instance()
		row.add_child(cell)
		cell.set_prop_id(idx)
		cell.set_row_idx(row_idx)
		cell.set_text("")
		cell.connect("edit_data", self, "on_edit_data")

# sets the table from database
func set_table(table : Object) -> void:
	# print("GDDBTableEditor::set_table(" + table.get_table_name() + ")")
	clear_current_layout()

	m_table = table
	fill_properties()
	fill_data()

# fills the interface with current table's properties
func fill_properties() -> void:
	var props_count = m_table.get_props_count()
	for idx in range(0, props_count):
		var db_prop = m_table.get_prop_at(idx)
		add_prop_to_structure(db_prop.get_prop_id(), db_prop.get_prop_type(), db_prop.get_prop_name())

		var prop = load(g_constants.c_addon_main_path + "data_label.tscn").instance()
		$tabs/data/data_holder/data_header.add_child(prop)
		prop.set_prop_id(db_prop.get_prop_id())
		prop.set_text(db_prop.get_prop_name())
	if(props_count > 0):
		$tabs/data/data_holder/btns/add_data_btn.set_disabled(false)

# fills the interface with current table's data
func fill_data() -> void:
	var rows_count = m_table.get_rows_count()
	for idx in range(0, rows_count):
		var row = HBoxContainer.new()
		$tabs/data/data_holder/data_container.add_child(row)
		var data_row = m_table.get_row_by_idx(idx)
		for jdx in range(0, data_row.size()):
			var cell = load(g_constants.c_addon_main_path + "table_cell.tscn").instance()
			row.add_child(cell)
			cell.set_prop_id(data_row[jdx].get_prop_id())
			cell.set_row_idx(idx)
			cell.set_text(data_row[jdx].get_data())
			cell.connect("edit_data", self, "on_edit_data")

# cleares current layout
func clear_current_layout():
	# clear structure tab
	for idx in range(0, $tabs/structure/properties.get_child_count()):
		$tabs/structure/properties.get_child(idx).queue_free()

	# clear data from data tab
	for idx in range(0, $tabs/data/data_holder/data_container.get_child_count()):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			row.get_child(jdx).queue_free()
		row.queue_free()

	# clear properties from data tab
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		$tabs/data/data_holder/data_header.get_child(idx).queue_free()

	$tabs/data/data_holder/btns/add_data_btn.set_disabled(true)

func on_edit_property(prop_id : int, prop_type : int, prop_name : String) -> void:
	# print("GDDBTableEditor::on_edit_property(" + str(prop_id) + ", " + db_types.get_data_name(prop_type) + ", " + prop_name + ")")
	# edit prop in the table
	m_table.edit_prop(prop_id, prop_type, prop_name)

	# refresh the prop name in data tab
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		var prop = $tabs/data/data_holder/data_header.get_child(idx)
		if(prop.get_prop_id() == prop_id):
			prop.set_text(prop_name)

func on_delete_property(prop_id : int) -> void:
	# print("GDDBTableEditor::on_delete_property(" + str(prop_id) + ")")
	# deletes property from table; also all data by this property
	m_table.delete_prop(prop_id)

	# delete cells from data tab
	for idx in range(0, $tabs/data/data_holder/data_container.get_child_count()):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			var cell = row.get_child(jdx)
			if(cell.get_prop_id() == prop_id):
				cell.disconnect("edit_data", self, "on_edit_data")
				cell.queue_free()
				break

	# delete property from data tab
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		var prop = $tabs/data/data_holder/data_header.get_child(idx)
		if(prop.get_prop_id() == prop_id):
			prop.queue_free()
			break

	# delete prop from structure
	for idx in range(0, $tabs/structure/properties.get_child_count()):
		var prop = $tabs/structure/properties.get_child(idx)
		if(prop.get_prop_id() == prop_id):
			prop.queue_free()
			break

func on_edit_data(prop_id : int, row_idx : int, data : String):
	m_table.edit_data(prop_id, row_idx, data)

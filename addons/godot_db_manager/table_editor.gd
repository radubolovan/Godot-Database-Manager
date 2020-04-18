"""
class GDDBTableEditor
"""

class_name GDDBTableEditor

tool
extends Control

signal set_dirty

var m_parent_table = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$tabs/structure/v_layout/btns/new_property_btn.connect("pressed", self, "on_new_property_btn_pressed")
	$tabs/data/scroll/data_holder/btns/add_data_btn.connect("pressed", self, "on_add_row_data_btn_pressed")
	$tabs/data/scroll/data_holder/btns/add_data_btn.set_disabled(true)

	$load_res_path_dlg.connect("file_selected", self, "on_select_res_path")

	$data_dlg.connect("select_data", self, "on_select_data")

	$edit_string_dlg.connect("string_edited", self, "on_text_edited")

	$delete_prop_dlg.connect("delete_prop", self, "on_confirm_delete_property")

# called when the new_property button is pressed
func on_new_property_btn_pressed() -> void:
	# print("GDDBTableEditor::on_new_property_btn_pressed()")
	if(null == m_parent_table):
		print("ERROR: GDDBTableEditor::on_new_property_btn_pressed() - m_parent_table is null")
		return
	var prop_idx = m_parent_table.get_props_count()
	var prop_type = gddb_types.e_prop_type_bool
	var prop_name = "Property_" + str(prop_idx+1)
	var prop_id = m_parent_table.add_prop(prop_type, prop_name)
	add_prop_to_structure(prop_id, prop_type, prop_name)
	add_prop_to_data(prop_id, prop_type, prop_name, false)

	# enable add data btn
	$tabs/data/scroll/data_holder/btns/add_data_btn.set_disabled(false)

	emit_signal("set_dirty")

# adds a property to structure tab
func add_prop_to_structure(prop_id : int, prop_type : int, prop_name : String) -> void:
	# print("GDDBTableEditor::add_prop_to_structure(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ")")
	var prop = load(gddb_constants.c_addon_main_path + "table_property.tscn").instance()
	$tabs/structure/v_layout/scroll/properties.add_child(prop)
	prop.set_parent_table(m_parent_table)
	prop.setup(prop_id, prop_type, prop_name)
	prop.connect("edit_property", self, "on_edit_property")
	prop.connect("delete_property", self, "on_delete_property")
	prop.connect("enable_autoincrement", self, "on_enable_prop_autoincrement")

# adds a property to data tab
func add_prop_to_data(prop_id : int, prop_type : int, prop_name : String, has_autoincrement : bool) -> void:
	var prop = load(gddb_constants.c_addon_main_path + "data_label.tscn").instance()
	$tabs/data/scroll/data_holder/data_header.add_child(prop)
	prop.set_prop_id(prop_id)
	prop.set_text(prop_name)

	# add property to the existing rows
	for idx in range(0, $tabs/data/scroll/data_holder/data_container.get_child_count()):
		var row = $tabs/data/scroll/data_holder/data_container.get_child(idx)
		var cell = load(gddb_constants.c_addon_main_path + "table_cell.tscn").instance()
		row.add_child(cell)
		cell.set_prop_id(prop_id)
		cell.set_row_idx(idx)
		cell.set_prop_type(prop_type)
		cell.set_text("")
		cell.refresh_width(prop_name)
		cell.enable_autoincrement(has_autoincrement)
		cell.connect("edit_data", self, "on_edit_data")
		cell.connect("choose_resource", self, "on_choose_resource")
		cell.connect("choose_data", self, "on_choose_data")
		cell.connect("edit_string", self, "on_edit_string")

# called when the add data button is pressed
func on_add_row_data_btn_pressed() -> void:
	# print("GDDBTableEditor::on_add_row_data_btn_pressed")
	# add blank row in the table
	var row_idx = m_parent_table.get_rows_count()
	m_parent_table.add_blank_row()

	# add row in the interface
	var row = HBoxContainer.new()
	$tabs/data/scroll/data_holder/data_container.add_child(row)
	for idx in range(0, $tabs/structure/v_layout/scroll/properties.get_child_count()):
		var cell = load(gddb_constants.c_addon_main_path + "table_cell.tscn").instance()
		var prop = $tabs/structure/v_layout/scroll/properties.get_child(idx)
		var db_prop = m_parent_table.get_prop_by_id(idx)
		row.add_child(cell)
		cell.set_prop_id(idx)
		cell.set_row_idx(row_idx)
		cell.set_prop_type(prop.get_prop_type())
		var autoincrement = db_prop.has_autoincrement()
		cell.enable_autoincrement(db_prop.has_autoincrement())
		if(autoincrement):
			cell.set_text(str(row_idx+1))
		cell.refresh_width(prop.get_prop_name())
		cell.connect("edit_data", self, "on_edit_data")
		cell.connect("choose_resource", self, "on_choose_resource")
		cell.connect("choose_data", self, "on_choose_data")
		cell.connect("edit_string", self, "on_edit_string")

	emit_signal("set_dirty")

# sets the table from database
func set_table(table : Object) -> void:
	# print("GDDBTableEditor::set_table(" + table.get_table_name() + ")")
	clear_current_layout()

	m_parent_table = table
	fill_properties()
	fill_data()

# fills the interface with current table's properties
func fill_properties() -> void:
	# print("GDDBTableEditor::fill_properties()")
	var props_count = m_parent_table.get_props_count()
	for idx in range(0, props_count):
		var db_prop = m_parent_table.get_prop_at(idx)
		add_prop_to_structure(db_prop.get_prop_id(), db_prop.get_prop_type(), db_prop.get_prop_name())
		var prop = load(gddb_constants.c_addon_main_path + "data_label.tscn").instance()
		$tabs/data/scroll/data_holder/data_header.add_child(prop)
		prop.set_prop_id(db_prop.get_prop_id())
		prop.set_prop_type(db_prop.get_prop_type())
		prop.set_text(db_prop.get_prop_name())
	if(props_count > 0):
		$tabs/data/scroll/data_holder/btns/add_data_btn.set_disabled(false)

# fills the interface with current table's data
func fill_data() -> void:
	#print("GDDBTableEditor::fill_data()")
	var rows_count = m_parent_table.get_rows_count()
	#print("Table name: " + m_parent_table.get_table_name())
	#print("rows_count: " + str(rows_count))
	for idx in range(0, rows_count):
		var row = HBoxContainer.new()
		$tabs/data/scroll/data_holder/data_container.add_child(row)
		var data_row = m_parent_table.get_data_at_row_idx(idx)
		for jdx in range(0, data_row.size()):
			var db_prop = m_parent_table.get_prop_at(jdx)
			#print("Prop id: " + str(db_prop.get_prop_id()))
			#print("Prop type: " + str(db_prop.get_prop_type()))
			#print("Prop name: " + str(db_prop.get_prop_name()))

			var cell = load(gddb_constants.c_addon_main_path + "table_cell.tscn").instance()
			var cell_data = data_row[jdx].get_data()

			var prop_type = db_prop.get_prop_type()
			if(prop_type >= gddb_types.e_prop_types_count):
				var db = m_parent_table.get_parent_database()
				var table = db.get_table_by_id(prop_type - gddb_types.e_prop_types_count)
				var data_row_idx = cell_data.to_int()
				cell_data = gddb_globals.get_json_from_row(table, data_row_idx)

			row.add_child(cell)

			cell.set_prop_id(data_row[jdx].get_prop_id())
			cell.set_row_idx(idx)
			cell.set_prop_type(prop_type)
			cell.set_text(cell_data)
			cell.refresh_width(db_prop.get_prop_name())
			cell.enable_autoincrement(db_prop.has_autoincrement())
			cell.connect("edit_data", self, "on_edit_data")
			cell.connect("choose_resource", self, "on_choose_resource")
			cell.connect("choose_data", self, "on_choose_data")
			cell.connect("edit_string", self, "on_edit_string")

# links properties
func link_props() -> void :
	# print("GDDBTableEditor::link_props() for table with name: " + m_parent_table.get_table_name())
	for idx in range(0, $tabs/structure/v_layout/scroll/properties.get_child_count()):
		var prop = $tabs/structure/v_layout/scroll/properties.get_child(idx)
		prop.link()

# refreshes autoincrement props
func refresh_autoincrement_props(prop_id, enable) -> void:
	for idx in range(0, $tabs/data/scroll/data_holder/data_container.get_child_count()):
		var row = $tabs/data/scroll/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			var cell = row.get_child(jdx)
			if(cell.get_prop_id() == prop_id):
				cell.enable_autoincrement(enable)

# cleares current layout
func clear_current_layout() -> void:
	# clear structure tab
	for idx in range(0, $tabs/structure/v_layout/scroll/properties.get_child_count()):
		$tabs/structure/v_layout/scroll/properties.get_child(idx).queue_free()

	# clear data from data tab
	for idx in range(0, $tabs/data/scroll/data_holder/data_container.get_child_count()):
		var row = $tabs/data/scroll/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			row.get_child(jdx).queue_free()
		row.queue_free()

	# clear properties from data tab
	for idx in range(0, $tabs/data/scroll/data_holder/data_header.get_child_count()):
		$tabs/data/scroll/data_holder/data_header.get_child(idx).queue_free()

	$tabs/data/scroll/data_holder/btns/add_data_btn.set_disabled(true)

# called when a property is edited
func on_edit_property(prop_id : int, prop_type : int, prop_name : String) -> void:
	"""
	print("GDDBTableEditor::on_edit_property(" + str(prop_id) + ", " + str(prop_type) + ", " + prop_name + ")")
	if(prop_type >= gddb_types.e_prop_types_count):
		var db = m_parent_table.get_parent_database()
		var selected_table = db.get_table_by_id(gddb_types.e_prop_types_count - prop_type)
		print("GDDBTableEditor::on_edit_property(" + str(prop_id) + ", " + selected_table.get_table_name() + ", " + prop_name + ")")
	else:
		print("GDDBTableEditor::on_edit_property(" + str(prop_id) + ", " + gddb_globals.get_data_name(prop_type) + ", " + prop_name + ")")
	#"""
	# edit prop in the table
	m_parent_table.edit_prop(prop_id, prop_type, prop_name)

	# refresh the prop name in data tab
	for idx in range(0, $tabs/data/scroll/data_holder/data_header.get_child_count()):
		var prop = $tabs/data/scroll/data_holder/data_header.get_child(idx)
		if(prop.get_prop_id() == prop_id):
			prop.set_text(prop_name)

	# update data type
	for idx in range(0, $tabs/data/scroll/data_holder/data_container.get_child_count()):
		var row = $tabs/data/scroll/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			var cell = row.get_child(jdx)
			if(cell.get_prop_id() == prop_id):
				"""
				if(prop_type < gddb_types.e_prop_types_count):
					print("Prop type: " + gddb_globals.get_data_name(prop_type))
				else:
					print("Prop type: custom")
				"""
				cell.set_prop_type(prop_type)

	emit_signal("set_dirty")

# called when a property is deleted
func on_delete_property(prop_id : int) -> void:
	# print("GDDBTableEditor::on_delete_property(" + str(prop_id) + ")")
	var prop = m_parent_table.get_prop_by_id(prop_id)
	$delete_prop_dlg.set_prop_id(prop_id)
	$delete_prop_dlg.set_prop_name(prop.get_prop_name())
	$delete_prop_dlg.popup_centered()

# called when a property is deleted
func on_confirm_delete_property() -> void:
	var prop_id = $delete_prop_dlg.get_prop_id()

	# deletes a property from table; also all data by this property
	m_parent_table.delete_prop(prop_id)

	# delete cells from data tab
	for idx in range(0, $tabs/data/scroll/data_holder/data_container.get_child_count()):
		var row = $tabs/data/scroll/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			var cell = row.get_child(jdx)
			if(cell.get_prop_id() == prop_id):
				cell.disconnect("edit_data", self, "on_edit_data")
				cell.queue_free()
				break

	# delete property from data tab
	for idx in range(0, $tabs/data/scroll/data_holder/data_header.get_child_count()):
		var prop = $tabs/data/scroll/data_holder/data_header.get_child(idx)
		if(prop.get_prop_id() == prop_id):
			prop.queue_free()
			break

	# delete prop from structure
	for idx in range(0, $tabs/structure/v_layout/scroll/properties.get_child_count()):
		var prop = $tabs/structure/v_layout/scroll/properties.get_child(idx)
		if(prop.get_prop_id() == prop_id):
			prop.queue_free()
			break

	# refresh the add data button
	var props_count = m_parent_table.get_props_count()
	if(props_count == 0):
		$tabs/data/scroll/data_holder/btns/add_data_btn.set_disabled(true)

	emit_signal("set_dirty")

# called when the property has autoincrement or not
func on_enable_prop_autoincrement(prop_id : int, enable : bool) -> void :
	m_parent_table.enable_prop_autoincrement(prop_id, enable)
	emit_signal("set_dirty")
	refresh_autoincrement_props(prop_id, enable)

	# reindex all data
	if(enable):
		for idx in range(0, $tabs/data/scroll/data_holder/data_container.get_child_count()):
			var row = $tabs/data/scroll/data_holder/data_container.get_child(idx)
			for jdx in range(0, row.get_child_count()):
				var cell = row.get_child(jdx)
				if(cell.get_prop_id() == prop_id):
					cell.set_text(str(idx + 1))

# called when edit data
func on_edit_data(prop_id : int, row_idx : int, data : String) -> void:
	m_parent_table.edit_data(prop_id, row_idx, data)
	emit_signal("set_dirty")

# called when choosing a resource
func on_choose_resource(prop_id : int, row_idx : int) -> void:
	# print("GDDBTableEditor::on_choose_resource(" + str(prop_id) + ", " + str(row_idx) + ")")
	$load_res_path_dlg.set_prop_id(prop_id)
	$load_res_path_dlg.set_row_idx(row_idx)
	$load_res_path_dlg.popup_centered()

# called when choosing a data
func on_choose_data(prop_id : int, row_idx : int, prop_type : int) -> void:
	# print("GDDBTableEditor::on_choose_data(" + str(prop_id) + ", " + str(row_idx) + ", " + str(prop_type) + ")")
	$data_dlg.set_prop_id(prop_id)
	$data_dlg.set_row_idx(row_idx)
	var table_id = prop_type - gddb_types.e_prop_types_count
	var db = m_parent_table.get_parent_database()
	var tbl = db.get_table_by_id(table_id)
	$data_dlg.set_table(tbl)
	$data_dlg.popup_centered()

# called when choosing to edit string
func on_edit_string(prop_id : int, row_idx : int, text : String) -> void:
	$edit_string_dlg.set_prop_id(prop_id)
	$edit_string_dlg.set_row_idx(row_idx)
	$edit_string_dlg.set_data_text(text)
	$edit_string_dlg.popup_centered()

# called when selecting a resource filepath
func on_select_res_path(filepath : String) -> void:
	# print("GDDBTableEditor::on_select_res_path(" + filepath + ")")
	var prop_id = $load_res_path_dlg.get_prop_id()
	var row_idx = $load_res_path_dlg.get_row_idx()
	m_parent_table.edit_data(prop_id, row_idx, filepath)
	var row = $tabs/data/scroll/data_holder/data_container.get_child(row_idx)
	for idx in range(0, row.get_child_count()):
		var cell = row.get_child(idx)
		if(cell.get_prop_id() == prop_id):
			cell.set_text(filepath)

	emit_signal("set_dirty")

# called when data from a table is choosen
func on_select_data(prop_id : int, row_idx : int, data_row_idx : int, data : String) -> void:
	# set the data in the databes / table
	m_parent_table.edit_data(prop_id, row_idx, str(data_row_idx))

	# fill in the interface cell with data
	var row = $tabs/data/scroll/data_holder/data_container.get_child(row_idx)
	for idx in range(0, row.get_child_count()):
		var cell = row.get_child(idx)
		if(cell.get_prop_id() == prop_id):
			cell.set_text(data)
			break

	emit_signal("set_dirty")

# called when the text is edited
func on_text_edited():
	var prop_id = $edit_string_dlg.get_prop_id()
	var row_idx = $edit_string_dlg.get_row_idx()
	var text_data = $edit_string_dlg.get_data_text()

	var data = gddb_globals.handle_string(text_data)

	# print("GDDBTableEditor::on_text_edited() - prop_id: " + str(prop_id) + ", row_idx: " + str(row_idx) + ", data: " + text_data)

	m_parent_table.edit_data(prop_id, row_idx, data)

	var row = $tabs/data/scroll/data_holder/data_container.get_child(row_idx)
	for idx in range(0, row.get_child_count()):
		var cell = row.get_child(idx)
		if(cell.get_prop_id() == prop_id):
			cell.set_text(text_data)
			break

	emit_signal("set_dirty")

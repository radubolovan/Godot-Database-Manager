tool
extends Control

signal new_property
signal edit_property
signal delete_property
signal new_data_row
signal edit_data

var m_props = []
var m_data = []

var m_add_data_button = null

func _ready() -> void:
	$tabs/structure/new_property_btn.connect("pressed", self, "on_new_property_btn_pressed")

# sets the current table
func set_table(table : Object) -> void:
	clear_current()
	var disable_add_button = true
	for idx in range(0, table.get_props_count()):
		var prop = load("res://addons/godot_db_manager/table_property.tscn").instance()
		m_props.push_back(prop)

		var db_prop = table.get_prop_at(idx)

		var prop_id = db_prop.get_prop_id()
		var prop_type = db_prop.get_prop_type()
		var prop_name = db_prop.get_prop_name()

		$tabs/structure/properties.add_child(prop)
		prop.setup(prop_id, prop_type, prop_name)
		prop.connect("edit_property", self, "on_edit_property")
		prop.connect("delete_property", self, "on_delete_property")

		var lbl = load("res://addons/godot_db_manager/data_label.tscn").instance()
		lbl.set_prop_id(prop_id)
		lbl.set_text(prop_name)
		$tabs/data/data_holder/data_header.add_child(lbl)

		disable_add_button = false

	var rows_count = table.get_rows_count()
	# print("Table \"" + table.get_name() + "\" has " + str(rows_count) + " rows")

	for idx in range(0, table.get_rows_count()):
		var row = HBoxContainer.new()
		$tabs/data/data_holder/data_container.add_child(row)
		var data = table.get_data_by_row_idx(idx)
		for jdx in range(0, data.size()):
			var cell = load("res://addons/godot_db_manager/table_cell.tscn").instance()
			cell.set_text(data[jdx].get_data())
			cell.set_prop_id(data[jdx].get_prop_id())
			cell.set_row_idx(idx)
			cell.connect("edit_data", self, "on_edit_data")
			row.add_child(cell)

	create_add_button(disable_add_button)

# clear table interface
func clear_current() -> void:
	clear_structure()
	clear_data()

# clears table structure
func clear_structure() -> void:
	for idx in range(0, $tabs/structure/properties.get_child_count()):
		var prop = $tabs/structure/properties.get_child(idx)
		prop.disconnect("edit_property", self, "on_edit_property")
		prop.disconnect("delete_property", self, "on_delete_property")
		prop.queue_free()
	m_props.clear()

# called when new property button is pressed
func on_new_property_btn_pressed() -> void:
	# add prop to structure
	var prop_id = m_props.size()
	var prop = load("res://addons/godot_db_manager/table_property.tscn").instance()

	m_props.push_back(prop)
	$tabs/structure/properties.add_child(prop)

	var prop_name = "property_" + str(prop_id + 1)
	var prop_type = 0 # integer

	prop.setup(prop_id, prop_type, prop_name)
	prop.connect("edit_property", self, "on_edit_property")
	prop.connect("delete_property", self, "on_delete_property")

	# add prop to data
	var lbl = load("res://addons/godot_db_manager/data_label.tscn").instance()
	lbl.set_prop_id(prop_id)
	lbl.set_text(prop_name)
	$tabs/data/data_holder/data_header.add_child(lbl)

	# last row is the "+" button
	var rows = $tabs/data/data_holder/data_container.get_child_count()
	for idx in range(0, rows-1):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		var cell = load("res://addons/godot_db_manager/table_cell.tscn").instance()
		cell.set_text("")
		cell.set_prop_id(prop_id)
		cell.set_row_idx(idx)
		cell.connect("edit_data", self, "on_edit_data")
		row.add_child(cell)

	if(null != m_add_data_button):
		m_add_data_button.set_disabled(false)

	emit_signal("new_property", prop_id, prop_type, prop_name)

# called when edit a property
func on_edit_property(prop_id : int, prop_type : int, prop_name : String) -> void:
	# update data header
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		if($tabs/data/data_holder/data_header.get_child(idx).get_prop_id() == prop_id):
			$tabs/data/data_holder/data_header.get_child(idx).set_text(prop_name)
	emit_signal("edit_property", prop_id, prop_type, prop_name)

# called when delete a property
func on_delete_property(prop_id : int) -> void:
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			m_props[idx].disconnect("edit_property", self, "on_edit_property")
			m_props[idx].disconnect("delete_property", self, "on_delete_property")
			$tabs/structure/properties.remove_child(m_props[idx])
			m_props.remove(idx)
			break
	# recreate properties' ids
	for idx in range(0, m_props.size()):
		m_props[idx].set_prop_id(idx)
	# update header data
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		var lbl = $tabs/data/data_holder/data_header.get_child(idx)
		var lbl_prop_id = lbl.get_prop_id()
		if(lbl_prop_id == prop_id):
			lbl.queue_free()
		elif(lbl_prop_id > prop_id):
			lbl.set_prop_id(lbl_prop_id-1)
	# update container data
	var rows = $tabs/data/data_holder/data_container.get_child_count()
	for idx in range(0, rows-1):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			var cell = row.get_child(jdx)
			var cell_prop_id = cell.get_prop_id()
			if(cell_prop_id == prop_id):
				cell.queue_free()
			elif(cell_prop_id > prop_id):
				cell.set_prop_id(cell_prop_id-1)
	emit_signal("delete_property", prop_id)

# create "+" button for adding new row of data
func create_add_button(disable : bool) -> void:
	if(null != m_add_data_button):
		m_add_data_button.set_disabled(disable)
		return
	var row = HBoxContainer.new()
	m_add_data_button = Button.new()
	m_add_data_button.set_text("+")
	m_add_data_button.connect("pressed", self, "on_plus_button")
	m_add_data_button.set_disabled(disable)
	row.add_child(m_add_data_button)
	$tabs/data/data_holder/data_container.add_child(row)

# clears data interface
func clear_data() -> void:
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		$tabs/data/data_holder/data_header.get_child(idx).queue_free()

	for idx in range(0, $tabs/data/data_holder/data_container.get_child_count()):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			# row.get_child(jdx).disconnect("edit_data", self, "on_edit_data")
			row.get_child(jdx).queue_free()
		row.queue_free()

	m_add_data_button = null

# called when add data button is pressed
func on_plus_button() -> void:
	var rows = $tabs/data/data_holder/data_container.get_child_count()
	var last_row = $tabs/data/data_holder/data_container.get_child(rows - 1)

	last_row.remove_child(m_add_data_button)

	for idx in range(0, m_props.size()):
		var cell = load("res://addons/godot_db_manager/table_cell.tscn").instance()
		cell.set_text("")
		cell.set_prop_id(idx)
		cell.set_row_idx(rows - 1)
		cell.connect("edit_data", self, "on_edit_data")
		last_row.add_child(cell)

	last_row = HBoxContainer.new()
	last_row.add_child(m_add_data_button)
	$tabs/data/data_holder/data_container.add_child(last_row)

	emit_signal("new_data_row")

# called when edit data
func on_edit_data(prop_id : int, row_idx : int, new_text : String):
	emit_signal("edit_data", prop_id, row_idx, new_text)


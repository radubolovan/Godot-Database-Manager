tool
extends Control

signal new_property
signal change_property
signal delete_property
signal new_data_row
signal update_data

var m_props = []
var m_data = []

var m_add_data_button = null

func _ready():
	$tabs/structure/new_property_btn.connect("pressed", self, "on_new_property_btn_pressed")

func set_table(table):
	clear_current()
	var disable_add_button = true
	for idx in range(0, table.get_props_count()):
		var prop = load("res://addons/godot_db_manager/table_property.tscn").instance()
		m_props.push_back(prop)

		var prop_id = table.get_prop_id(idx)
		var prop_type = table.get_prop_type(idx)
		var prop_name = table.get_prop_name(idx)

		$tabs/structure/properties.add_child(prop)
		prop.setup(table.get_prop_id(idx), table.get_prop_type(idx), table.get_prop_name(idx))
		prop.connect("update_property", self, "on_update_property")
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
			cell.connect("update_cell_data", self, "on_update_data")
			row.add_child(cell)

	create_add_button(disable_add_button)

func clear_current():
	clear_structure()
	clear_data()

func clear_structure():
	for idx in range(0, $tabs/structure/properties.get_child_count()):
		var prop = $tabs/structure/properties.get_child(idx)
		prop.disconnect("update_property", self, "on_update_property")
		prop.disconnect("delete_property", self, "on_delete_property")
		prop.queue_free()
	m_props.clear()

func on_new_property_btn_pressed():
	# add prop to structure
	var prop_id = m_props.size()
	var prop = load("res://addons/godot_db_manager/table_property.tscn").instance()

	m_props.push_back(prop)
	$tabs/structure/properties.add_child(prop)

	var prop_name = "property_" + str(prop_id + 1)
	var prop_type = 0 # integer

	prop.setup(prop_id, prop_type, prop_name)
	prop.connect("update_property", self, "on_update_property")
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
		cell.connect("update_cell_data", self, "on_update_data")
		row.add_child(cell)

	if(null != m_add_data_button):
		m_add_data_button.set_disabled(false)

	emit_signal("new_property", prop_id, prop_type, prop_name)

func on_update_property(prop_id, prop_type, prop_name):
	# update data header
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		if($tabs/data/data_holder/data_header.get_child(idx).get_prop_id() == prop_id):
			$tabs/data/data_holder/data_header.get_child(idx).set_text(prop_name)
	emit_signal("change_property", prop_id, prop_type, prop_name)

func on_delete_property(prop_id):
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_prop_id() == prop_id):
			m_props[idx].disconnect("update_property", self, "on_update_property")
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

func create_add_button(disable):
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

func clear_data():
	for idx in range(0, $tabs/data/data_holder/data_header.get_child_count()):
		$tabs/data/data_holder/data_header.get_child(idx).queue_free()

	for idx in range(0, $tabs/data/data_holder/data_container.get_child_count()):
		var row = $tabs/data/data_holder/data_container.get_child(idx)
		for jdx in range(0, row.get_child_count()):
			# row.get_child(jdx).disconnect("update_cell_data", self, "on_update_data")
			row.get_child(jdx).queue_free()
		row.queue_free()

	m_add_data_button = null

func on_plus_button():
	var rows = $tabs/data/data_holder/data_container.get_child_count()
	var last_row = $tabs/data/data_holder/data_container.get_child(rows - 1)

	last_row.remove_child(m_add_data_button)

	for idx in range(0, m_props.size()):
		var cell = load("res://addons/godot_db_manager/table_cell.tscn").instance()
		cell.set_text("")
		cell.set_prop_id(idx)
		cell.set_row_idx(rows - 1)
		cell.connect("update_cell_data", self, "on_update_data")
		last_row.add_child(cell)

	last_row = HBoxContainer.new()
	last_row.add_child(m_add_data_button)
	$tabs/data/data_holder/data_container.add_child(last_row)

	emit_signal("new_data_row")

func on_update_data(prop_id, row_idx, new_text):
	emit_signal("update_data", prop_id, row_idx, new_text)

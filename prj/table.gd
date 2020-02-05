extends Control

#const c_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#const c_chars = "ABCDE"

# var m_header = null
# var m_rows = []

var m_props = []

func _ready():
	$tabs/structure/new_property_btn.connect("pressed", self, "on_new_property_btn_pressed")

func on_new_property_btn_pressed():
	var prop_id = m_props.size()
	var prop = load("res://table_property.tscn").instance()

	m_props.push_back(prop)
	$tabs/structure/tables.add_child(prop)

	prop.setup(prop_id, str(prop_id + 1), g_types.e_column_type_int)
	prop.connect("delete_property", self, "on_delete_property")

func on_delete_property(prop_id):
	for idx in range(0, m_props.size()):
		if(m_props[idx].get_id() == prop_id):
			$tabs/structure/tables.remove_child(m_props[idx])
			m_props.remove(idx)
			break

	for idx in range(0, m_props.size()):
		m_props[idx].set_id(idx)

	#create_header()
	#$table/new_column_btn.connect("pressed", self, "on_add_column_btn_pressed")

	#$tabs.add_tab("Structure")
	#$tabs.add_tab("Data")

	"""
	add_column(0, " ")
	for idx in range(0, c_chars.length()):
		add_column(idx+1, c_chars[idx])

	var begin = OS.get_ticks_msec()
	var rows = 101
	for idx in range(0, rows):
		add_row()
	var total = OS.get_ticks_msec() - begin
	# print(str( (c_chars.length() + 1) * (rows + 1) ) + " cells created in " + str(int(float(total) / 1000.0)) + " seconds")
	"""

"""
func create_header():
	m_header = HBoxContainer.new()
	#$table/val.add_child(m_header)

func add_row():
	var row = g_types.cRow.new()
	row.m_id = m_rows.size()

	var the_row = HBoxContainer.new()
	for idx in range(0, m_header.get_child_count()):
		var cell = row.add_column(idx, "")
		the_row.add_child(cell)

	m_rows.push_back(the_row)
	$table/val.add_child(the_row)

func add_column(idx, column_name):
	var lbl = load("res://table_label.tscn").instance()
	if(idx == 0):
		lbl.set_custom_minimum_size(Vector2(20, 20))
	else:
		lbl.set_custom_minimum_size(Vector2(100, 20))
	lbl.set_align(Label.ALIGN_CENTER)
	lbl.set_valign(Label.VALIGN_CENTER)
	lbl.set_text(column_name)
	#m_header.add_child(lbl)

	var column = g_types.cColumn.new()
	column.m_name = column_name

func on_add_column_btn_pressed():
	$new_column_dlg.refresh()
	$new_column_dlg.popup_centered()
"""

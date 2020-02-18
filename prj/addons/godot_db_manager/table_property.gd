tool
extends Control

signal delete_property
signal edit_property

var m_id : int = -1
var m_type : int = 0
var m_name : String = ""

func _ready() -> void:
	$align/prop_name.connect("text_changed", self, "on_name_changed")

	for idx in range(0, gd_types.e_data_types_count):
		$align/prop_type.add_item(gd_types.get_data_name(idx))

	$align/prop_type.connect("item_selected", self, "on_type_changed")

	$align/close_button.connect("pressed", self, "on_delete_button_pressed")

# setup property
func setup(id : int, type : int, name : String) -> void:
	set_prop_id(id)
	set_prop_type(type)
	set_prop_name(name)

# sets proprty id
func set_prop_id(id : int) -> void:
	m_id = id
	$align/prop_id.set_text(str(m_id))

# returns property id
func get_prop_id() -> int:
	return m_id

# sets property type
func set_prop_type(type : int) -> void:
	m_type = type
	if(m_type == 0): # integer
		$align/prop_type.select(0)
	elif(m_type == 1): # string
		$align/prop_type.select(1)

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

# called everytime the type of the property is changed
func on_type_changed(new_type : int) -> void:
	m_type = new_type
	emit_signal("edit_property", m_id, m_type, m_name)

# called when the delete property button is pressed
func on_delete_button_pressed() -> void:
	emit_signal("delete_property", m_id)

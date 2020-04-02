"""
class GDDBMenu
"""

class_name GDDBMenu

tool
extends Control

signal new_database
signal load_database
signal save_database
signal save_database_as

enum {
	e_file_new_id = 0,
	e_file_load_id = 1
	e_file_save_id = 2,
	e_file_save_as_id = 3,

	e_option_autosave_on_close_id = 4
}

var m_enable_new_db = true
var m_enable_load_db = true
var m_enable_save_db = false
var m_enable_save_as_db = false

var m_check_autosave_on_load = false

func _ready() -> void:
	$layout/File.connect("about_to_show", self, "on_about_to_show_file_menu")
	$layout/File.get_popup().clear()
	$layout/File.get_popup().add_item("New DB", e_file_new_id)
	$layout/File.get_popup().add_item("Load DB", e_file_load_id)
	$layout/File.get_popup().add_item("Save DB", e_file_save_id)
	$layout/File.get_popup().add_item("Save DB As ...", e_file_save_as_id)
	$layout/File.get_popup().connect("id_pressed", self, "on_file_id_pressed")

	$layout/Options.connect("about_to_show", self, "on_about_to_show_options_menu")
	$layout/Options.get_popup().clear()
	$layout/Options.get_popup().add_check_item("Autosave on close", e_option_autosave_on_close_id)
	$layout/Options.get_popup().connect("id_pressed", self, "on_options_id_pressed")

# called before showing the file menu
func on_about_to_show_file_menu() -> void:
	for idx in range(0, $layout/File.get_popup().get_item_count()):
		var item_id = $layout/File.get_popup().get_item_id(idx)
		if(item_id == e_file_new_id):
			$layout/File.get_popup().set_item_disabled(idx, !m_enable_new_db)
		elif(item_id == e_file_load_id):
			$layout/File.get_popup().set_item_disabled(idx, !m_enable_load_db)
		elif(item_id == e_file_save_id):
			$layout/File.get_popup().set_item_disabled(idx, !m_enable_save_db)
		elif(item_id == e_file_save_as_id):
			$layout/File.get_popup().set_item_disabled(idx, !m_enable_save_as_db)

# enables / disables the possibility to create a new databbase
func enable_file_new(enable) -> void:
	m_enable_new_db = enable

# enables / disables the possibility to load a databbase
func enable_file_load(enable) -> void:
	m_enable_load_db = enable

# enables / disables the possibility to save a databbase
func enable_file_save(enable) -> void:
	m_enable_save_db = enable

# enables / disables the possibility to save a databbase as another
func enable_file_save_as(enable) -> void:
	m_enable_save_as_db = enable

# called when the user clicks on a file menu item
func on_file_id_pressed(id : int) -> void:
	if(id == e_file_new_id):
		emit_signal("new_database")
	elif(id == e_file_load_id):
		emit_signal("load_database")
	elif(id == e_file_save_id):
		emit_signal("save_database")
	elif(id == e_file_save_as_id):
		emit_signal("save_database_as")

# called before showing the option menu
func on_about_to_show_options_menu() -> void:
	for idx in range(0, $layout/Options.get_popup().get_item_count()):
		var item_id = $layout/Options.get_popup().get_item_id(idx)
		if(item_id == e_option_autosave_on_close_id):
			$layout/Options.get_popup().set_item_checked(idx, m_check_autosave_on_load)

# enables / disables the possibility to autosave all databases on close
func enable_autosave_on_close(enable) -> void:
	m_check_autosave_on_load = enable

# called when the user clicks on a options menu item
func on_options_id_pressed(id : int) -> void:
	if(id == e_option_autosave_on_close_id):
		enable_autosave_on_close(!m_check_autosave_on_load)

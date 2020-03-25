"""
class GDDBManager
"""

class_name GDDBManager

tool
extends EditorPlugin

var DBInterface = preload("./db_interface.tscn")
var db_interface : Node

func _enter_tree():
	add_autoload_singleton("g_constants", "res://addons/godot_db_manager/constants.gd")
	add_autoload_singleton("db_types", "res://addons/godot_db_manager/core/db_types.gd")
	add_autoload_singleton("g_globals", "res://addons/godot_db_manager/globals.gd")

	# Initialization of the plugin goes here
	db_interface = DBInterface.instance()

	get_editor_interface().get_base_control().add_child(db_interface)
	add_tool_menu_item("Godot Database Manager", self, "open_config")
	window = db_interface.get_node("dlg") as WindowDialog

func _exit_tree():
	# Clean-up of the plugin goes here
	remove_tool_menu_item("Godot Database Manager")
	if(db_interface):
		db_interface.queue_free()

var window:WindowDialog
var opened:bool = false
func open_config(UD):
	if(window):
		window.popup_centered()

func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_F10):
			if(window):
				if !opened:
					window.popup_centered()
					opened = true
				else:
					window.hide()
					opened = false
				


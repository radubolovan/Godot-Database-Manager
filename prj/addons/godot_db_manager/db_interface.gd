tool
extends Control

var m_databases = []

func _ready() -> void:
	# menu connections
	$dlg/menu.connect("menu_about_to_show", self, "on_show_menu")
	$dlg/menu.connect("menu_hide", self, "on_hide_menu")
	$dlg/menu.connect("new_database", self, "on_menu_new_database")
	$dlg/menu.connect("load_database", self, "on_menu_load_database")
	$dlg/menu.connect("save_database", self, "on_menu_save_database")
	$dlg/menu.connect("save_database_as", self, "on_menu_save_database_as")

	# new database connections
	$dlg/new_db_dlg.connect("create_new_db", self, "on_new_database")

# called when a menu is about to be shown
func on_show_menu():
	$dlg/databases.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

# called when closing a menu
func on_hide_menu():
	$dlg/databases.set_mouse_filter(Control.MOUSE_FILTER_STOP)

# called when creating a new database from the menu
func on_menu_new_database():
	$dlg/new_db_dlg/db_info/db_edt.set_text("")
	$dlg/new_db_dlg.popup_centered()

# called when loading a database from the menu
func on_menu_load_database():
	print("on_menu_load_database")

# called when saving a database from the menu
func on_menu_save_database():
	print("on_menu_save_database")

# called when saving a database as another from the menu
func on_menu_save_database_as():
	print("on_menu_save_database_as")

func on_new_database(db_name):
	var db_interface = load("res://addons/godot_db_manager/db_editor.tscn").instance()
	db_interface.set_name(db_name)
	$dlg/databases.add_child(db_interface)

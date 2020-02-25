tool
extends Control

var m_databases = []

# Called when the node enters the scene tree for the first time.
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
func on_show_menu() -> void:
	$dlg/databases.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

# called when closing a menu
func on_hide_menu() -> void:
	$dlg/databases.set_mouse_filter(Control.MOUSE_FILTER_STOP)

# called when creating a new database from the menu
func on_menu_new_database() -> void:
	$dlg/new_db_dlg/v_layout/db_info/db_edt.set_text("")
	$dlg/new_db_dlg.popup_centered()

# called when loading a database from the menu
func on_menu_load_database() -> void:
	print("on_menu_load_database")

# called when saving a database from the menu
func on_menu_save_database() -> void:
	print("on_menu_save_database")

# called when saving a database as another from the menu
func on_menu_save_database_as():
	print("on_menu_save_database_as")

func on_new_database(db_name : String) -> void:
	var tmp_name = db_name.to_lower()
	for idx in range(0, m_databases.size()):
		if(m_databases[idx].get_db_name() == tmp_name):
			return

	var db = load(g_constants.c_addon_main_path + "core/database.gd").new()
	db.set_db_name(db_name)
	m_databases.push_back(db)

	var db_interface = load(g_constants.c_addon_main_path + "db_editor.tscn").instance()
	db_interface.set_name(db_name)
	db_interface.set_dirty(true)
	db_interface.set_database(db)
	$dlg/databases.add_child(db_interface)

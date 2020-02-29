"""
class GDDBInterface
"""

class_name GDDBInterface

tool
extends Control

var m_db_manager = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# init db_manager
	m_db_manager = load(g_constants.c_addon_main_path + "core/db_man.gd").new()

	# menu connections
	$dlg/menu.connect("new_database", self, "on_menu_new_database")
	$dlg/menu.connect("load_database", self, "on_menu_load_database")
	$dlg/menu.connect("save_database", self, "on_menu_save_database")
	$dlg/menu.connect("save_database_as", self, "on_menu_save_database_as")

	# databases connections
	$dlg/databases.connect("tab_changed", self, "on_tab_changed")

	# new database connections
	$dlg/new_db_dlg.connect("create_new_db", self, "on_new_database")

	# save / load connections
	$dlg/load_db_dlg.connect("file_selected", self, "on_file_selected")

# called when creating a new database from the menu
func on_menu_new_database() -> void:
	$dlg/new_db_dlg/v_layout/db_info/db_edt.set_text("")
	$dlg/new_db_dlg.popup_centered()

# called when loading a database from the menu
func on_menu_load_database() -> void:
	print("on_menu_load_database")

# called when saving a database from the menu
func on_menu_save_database() -> void:
	# print("on_menu_save_database")
	var db = m_db_manager.get_current_db()
	if(null == db):
		$dlg/error_dlg.set_text("There is no current database")
		$dlg/error_dlg.popup_centered()
		return
	var db_path = db.get_db_path()
	if(db_path.empty()):
		on_menu_save_database_as()
	else:
		save_database(db)

# called when saving a database as another from the menu
func on_menu_save_database_as():
	# print("on_menu_save_database_as")
	$dlg/load_db_dlg.set_mode(FileDialog.MODE_SAVE_FILE)
	$dlg/load_db_dlg.set_title("Save Database As ...")
	$dlg/load_db_dlg.popup_centered()

# called when adding a new database
func on_new_database(db_name : String) -> void:
	var tmp_name = db_name.to_lower()
	var db_id = m_db_manager.add_database(db_name)
	if(db_id == g_constants.c_invalid_id):
		$dlg/error_dlg.set_text("Database with name \"" + db_name + "\" already exists")
		$dlg/error_dlg.popup_centered()
		return

	var db = m_db_manager.get_db_by_id(db_id)
	# print("new DB added: " + str(db))

	var db_interface = load(g_constants.c_addon_main_path + "db_editor.tscn").instance()
	db_interface.set_name(db_name)
	db.set_dirty(true)
	db_interface.set_database(db)
	$dlg/databases.add_child(db_interface)

	$dlg/menu.enable_file_save(true)
	$dlg/menu.enable_file_save_as(true)

# called selecting a tab
func on_tab_changed(tab_idx : int) -> void :
	m_db_manager.set_current_db_at(tab_idx)

# called when selecting a file from save / load dialog
func on_file_selected(filepath : String) -> void:
	if($dlg/load_db_dlg.get_mode() == FileDialog.MODE_SAVE_FILE):
		save_database_as(filepath)
	elif($dlg/load_db_dlg.get_mode() == FileDialog.MODE_OPEN_FILE):
		load_database(filepath)

# saves a database to a given file path
func save_database_as(filepath : String) -> void:
	# print("GDDBInterface::save_database_as(" + filepath + ")")
	var db = m_db_manager.get_current_db()
	db.set_db_filepath(filepath)
	save_database(db)

# save the current database
func save_database(db):
	db.save_db()
	var database = $dlg/databases.get_current_tab_control()
	database.set_dirty(false)

func load_database(filepath : String) -> void:
	print("GDDBInterface::load_database(" + filepath + ")")

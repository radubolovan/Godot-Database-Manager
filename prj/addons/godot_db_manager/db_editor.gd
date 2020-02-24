tool
extends Tabs

var m_name = ""
var m_database = null

func _ready() -> void:
	set_tab_align(Tabs.ALIGN_LEFT)
	set_tab_close_display_policy(Tabs.CLOSE_BUTTON_SHOW_ALWAYS)

	$main_window/tables_panel/tables_list.connect("add_table", self, "on_add_table")
	$new_table_dlg.connect("create_new_table", self, "on_create_table")

# overrides the member from base class
func set_name(name) -> void:
	m_name = name
	.set_name(name)

# sets the database; for easy access
func set_database(db) -> void:
	m_database = db

# sets the database to be dirty; should be saved
func set_dirty(dirty) -> void:
	if(dirty):
		var title = m_name + "*"
		.set_name(title)
	else:
		.set_name(m_name)

func on_add_table():
	$new_table_dlg.set_init_name(name)
	$new_table_dlg.popup_centered()

func on_create_table(name):
	var table = m_database.add_table(name)
	if(null == table):
		# TODO: popup an error here and retry
		$new_table_dlg.set_init_name(name)
		$new_table_dlg.popup_centered()
		return

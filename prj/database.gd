extends Control

func _ready():
	$menu/new_table_btn.connect("pressed", self, "on_new_table_btn_pressed")

	$new_table_dlg.add_cancel("Cancel")
	$new_table_dlg.connect("create_new_table", self, "on_table_created")

	$tables_container.connect("item_selected", self, "on_select_table")

func on_new_table_btn_pressed():
	$new_table_dlg/table_info/table_edt.set_text("")
	$new_table_dlg.popup_centered()

func on_table_created(table_name):
	$tables_container.add_item(table_name)
	$tables_container.select(0)
	on_select_table(0)

func on_select_table(table_idx):
	# print("Selecting: " + $tables/HBoxContainer/ItemList.get_item_text(table_idx))
	$table.show()

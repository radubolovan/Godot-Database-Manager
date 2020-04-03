extends Control

var m_db_manager = null
var m_database = null

var m_player_name = ""
var m_player_name_prop_id = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# init database manager
	m_db_manager = load(gddb_constants.c_addon_main_path + "core/db_man.gd").new()
	var db_id = m_db_manager.load_database("res://examples/game_data.json")

	if(db_id == gddb_types.e_db_invalid_file):
		return

	if(db_id == gddb_types.e_db_invalid_ver):
		return

	# load the database
	m_database = m_db_manager.get_db_by_id(db_id)

	# get the tables
	var res_table = m_database.get_table_by_name("resources")
	var users_table = m_database.get_table_by_name("users")

	# get user data
	var user_data = users_table.get_data_at_row_idx(0)
	m_player_name = ""
	m_player_name_prop_id = -1
	for idx in range(0, users_table.get_props_count()):
		# set player name
		if(users_table.get_prop_at(idx).get_prop_name() == "name"):
			m_player_name_prop_id = users_table.get_prop_at(idx).get_prop_id()
			m_player_name = user_data[idx].get_data()

		# set energy
		elif(users_table.get_prop_at(idx).get_prop_name() == "energy"):
			var energy_idx = user_data[idx].get_data().to_int()
			var res_row = res_table.get_data_at_row_idx(energy_idx)
			for jdx in range(0, res_row.size()):
				if(res_table.get_prop_at(jdx).get_prop_name() == "name"):
					$energy.set_res_name(res_row[jdx].get_data())
				elif(res_table.get_prop_at(jdx).get_prop_name() == "img_path"):
					$energy.set_tex(res_row[jdx].get_data())
		elif(users_table.get_prop_at(idx).get_prop_name() == "energy_amount"):
			$energy.set_amount(user_data[idx].get_data().to_int())

		# set food
		elif(users_table.get_prop_at(idx).get_prop_name() == "food"):
			var food_idx = user_data[idx].get_data().to_int()
			var res_row = res_table.get_data_at_row_idx(food_idx)
			for jdx in range(0, res_row.size()):
				if(res_table.get_prop_at(jdx).get_prop_name() == "name"):
					$food.set_res_name(res_row[jdx].get_data())
				elif(res_table.get_prop_at(jdx).get_prop_name() == "img_path"):
					$food.set_tex(res_row[jdx].get_data())
		elif(users_table.get_prop_at(idx).get_prop_name() == "food_amount"):
			$food.set_amount(user_data[idx].get_data().to_int())

		# set wood
		elif(users_table.get_prop_at(idx).get_prop_name() == "wood"):
			var wood_idx = user_data[idx].get_data().to_int()
			var res_row = res_table.get_data_at_row_idx(wood_idx)
			for jdx in range(0, res_row.size()):
				if(res_table.get_prop_at(jdx).get_prop_name() == "name"):
					$wood.set_res_name(res_row[jdx].get_data())
				elif(res_table.get_prop_at(jdx).get_prop_name() == "img_path"):
					$wood.set_tex(res_row[jdx].get_data())
		elif(users_table.get_prop_at(idx).get_prop_name() == "wood_amount"):
			$wood.set_amount(user_data[idx].get_data().to_int())

		# set stone
		elif(users_table.get_prop_at(idx).get_prop_name() == "stone"):
			var stone_idx = user_data[idx].get_data().to_int()
			var res_row = res_table.get_data_at_row_idx(stone_idx)
			for jdx in range(0, res_row.size()):
				if(res_table.get_prop_at(jdx).get_prop_name() == "name"):
					$stone.set_res_name(res_row[jdx].get_data())
				if(res_table.get_prop_at(jdx).get_prop_name() == "img_path"):
					$stone.set_tex(res_row[jdx].get_data())
		elif(users_table.get_prop_at(idx).get_prop_name() == "stone_amount"):
			$stone.set_amount(user_data[idx].get_data().to_int())

	# init interface with user data
	$player_name_btn.set_text(m_player_name)
	$player_name_btn.connect("pressed", self, "on_player_name_btn_pressed")

	# init interface dialogs
	$edit_player_dlg/OK_btn.connect("pressed", self, "on_change_player_name_btn_pressed")
	$error_dlg.add_cancel("Cancel")
	$error_dlg.connect("confirmed", self, "on_player_name_btn_pressed")

# called when player_name_btn is pressed
func on_player_name_btn_pressed() -> void:
	$edit_player_dlg/player_name.set_text(m_player_name)
	$edit_player_dlg.popup_centered()

# called when the "OK" button from the edit_player_dlg is pressed
func on_change_player_name_btn_pressed() -> void:
	$edit_player_dlg.hide()

	# check if the name entered is empty
	var player_name = $edit_player_dlg/player_name.get_text()
	if(player_name.empty()):
		$error_dlg.popup_centered()
		$error_dlg.set_text("Player name is empty. Retry ?")
		return

	m_player_name = player_name

	# set the new name in the database
	var users_table = m_database.get_table_by_name("users")
	users_table.edit_data(m_player_name_prop_id, 0, m_player_name)

	# saving the database
	m_database.save_db()

	# set new name in the interface
	$player_name_btn.set_text(m_player_name)

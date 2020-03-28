"""
class GDDBConstants
"""

class_name GDDBConstants

tool
extends Node

# invalid id to initialize integer properties
const c_invalid_id = -1

# maximum database name length
const c_max_db_name_len = 16

# maximum table name length
const c_max_table_name_len = 16

# characters that should not be part of the database name
const c_invalid_characters = "`~!@#$%^&*()=+[]{}\\|;:'\",<.>/?"

# addon main path
const c_addon_main_path = "res://addons/godot_db_manager/"

# checks the name of the database
func check_db_name(name : String) -> bool :
	for idx in range(0, name.length()):
		for jdx in range(0, gddb_constants.c_invalid_characters.length()):
			if(name[idx] == gddb_constants.c_invalid_characters[jdx]):
				return false
	return true

"""
class GDDBGlobals
"""

class_name GDDBGlobals

tool
extends Node

# checks the name of the database
func check_db_name(db_name : String) -> bool :
	for idx in range(0, db_name.length()):
		for jdx in range(0, gddb_constants.c_invalid_characters.length()):
			if(db_name[idx] == gddb_constants.c_invalid_characters[jdx]):
				return false
	return true

# returns a json from a row from a table
func get_json_from_row(table : Object, row_idx : int) -> String:
	var json = "{"
	var row = table.get_data_at_row_idx(row_idx)
	for jdx in range(0, row.size()):
		var prop = table.get_prop_at(jdx)
		json += "\"" + prop.get_prop_name() + "\":"
		json += "\"" + row[jdx].get_data() + "\""
		if(jdx < row.size() - 1):
			json += ", "
	json += "}"
	return json

# returns the digits count from a number
func get_digits_count(number : int) -> int:
	if(number == 0):
		return 1

	var digits_count = 0
	while(number > 0):
		number /= 10
		digits_count += 1

	return digits_count

# replace special characters in a string to handle properly saving into database
func handle_string(text : String) -> String:
	var string = ""
	for idx in range(0, text.length()):
		if(text[idx] == "\n"):
			string += "\\n"
		else:
			string += text[idx]
	return string

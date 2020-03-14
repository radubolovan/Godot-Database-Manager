"""
class GDDBGlobals
"""

class_name GDDBGlobals

tool
extends Node

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

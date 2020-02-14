extends Control

func _ready():
	load_database()

func on_save_database():
	var table_names = ["res", "users"]
	var prop_names = [
		[
			"p1",
			"p2",
			"p3"
		],
		[
			"p1",
			"p2"
		]
	]
	var prop_types = [
		[
			"t1",
			"t1",
			"t1"
		],
		[
			"t2",
			"t2"
		]
	]
	var data = [
		["1","2","3","4","5","6","7","8","9"],
		["aa","bbb","cccc","ddddd"]
	]
	
	var text = "{"
	text += "\"tables\":["
	for idx in range(0, table_names.size()):
		text += "{"
		text += "\"name\":\"" + table_names[idx] + "\","
		text += "\"props\":["
		for jdx in range(0, prop_names[idx].size()):
			text += "{"
			var val_1 = prop_names[idx][jdx]
			var val_2 = prop_types[idx][jdx]
			text += "\"name\":\"" + val_1 + "\","
			text += "\"type\":\"" + val_2 + "\""
			text += "}"
			if(jdx < prop_names[idx].size() - 1):
				text += ","
		text += "],"

		text += "\"data\":["
		for jdx in range(0, data[idx].size()):
			#var the_data = m_tables[idx].get_data_at(jdx)
			#print("getting data at " + str(jdx) + " : " + the_data)
			text += "\"" + data[idx][jdx] + "\""
			if(jdx < data[idx].size() - 1):
				text += ","
		text += "]" # end of data
		text += "}" # end of table

		if(idx < table_names.size() - 1):
			text += ","

	text += "]}"

	var save_file = File.new()
	save_file.open("res://database.json", File.WRITE)
	save_file.store_string(text)
	save_file.close()

func load_database():
	var open_file = File.new()
	open_file.open("res://database.json", File.READ)
	var content = open_file.get_as_text()
	open_file.close()
	var dictionary = JSON.parse(content).result
	# print(dictionary)
	var tables = dictionary["tables"]
	for idx in range(0, tables.size()):
		print("table_name: " + tables[idx]["name"])
		var table = tables[idx]
		for jdx in range(0, tables[idx]["props"].size()):
			print("prop_name: " + tables[idx]["props"][jdx]["name"] + ", prop_type: " + tables[idx]["props"][jdx]["type"])
		for jdx in range(0, tables[idx]["data"].size()):
			print("data[" + str(jdx) + "] = " + tables[idx]["data"][jdx])

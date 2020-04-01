tool
extends Node

class_name GDDBTypes

enum {
	e_db_invalid_file = -11,
	e_db_invalid_ver = -10,
	e_db_valid = 0
}

enum {
	e_prop_type_bool = 0
	e_prop_type_int = 1,
	e_prop_type_float = 2,
	e_prop_type_string = 3,

	# TODO: insert more data types here and increase e_prop_type_resource

	e_prop_type_resource = 4,

	e_data_types_count
}

enum {
	e_data_filter_equal = 0,
	e_data_filter_not_equal = 1,
	e_data_filter_less = 2,
	e_data_filter_greater = 3,
	e_data_filter_lequal = 4, # less or equal
	e_data_filter_gequal = 5 # greater or equal
}

func _enter_tree():
	pass

func _exit_tree():
	pass

# returns the name of the data type
func get_data_name(data_type):
	if(data_type == e_prop_type_bool):
		return "Bool"
	elif(data_type == e_prop_type_int):
		return "Integer"
	elif(data_type == e_prop_type_float):
		return "Float"
	elif(data_type == e_prop_type_string):
		return "String"
	elif(data_type == e_prop_type_resource):
		return "Resource"

# returns the name of the data function
func get_data_function_name(data_func : int) -> String :
	if(data_func == e_data_filter_equal):
		return "Equal"
	elif(data_func == e_data_filter_not_equal):
		return "Not equal"
	elif(data_func == e_data_filter_less):
		return "Less"
	elif(data_func == e_data_filter_greater):
		return "Greater"
	elif(data_func == e_data_filter_lequal):
		return "Less or equal"
	elif(data_func == e_data_filter_gequal):
		return "Greater or equal"
	return "ERROR: Unknown data function :" + str(data_func)

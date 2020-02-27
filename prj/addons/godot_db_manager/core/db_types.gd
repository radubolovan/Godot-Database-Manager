tool
extends Node

class_name GDDBTypes

enum {
	e_prop_type_bool = 0
	e_prop_type_int = 1,
	e_prop_type_float = 2,
	e_prop_type_string = 3,
	e_prop_type_resource = 4,
	e_prop_type_data = 5,

	e_data_types_count
}

func _enter_tree():
	pass

func _exit_tree():
	pass

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
	elif(data_type == e_prop_type_data):
		return "Data"

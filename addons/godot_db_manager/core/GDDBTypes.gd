"""
class GDDBTypes
"""

class_name GDDBTypes

tool
extends Node

# Database loading errors
enum {
	e_db_invalid_file = -11,
	e_db_invalid_ver = -10,
	e_db_valid = 0
}

# Property types
enum {
	e_prop_type_bool = 0
	e_prop_type_int = 1,
	e_prop_type_float = 2,
	e_prop_type_string = 3,

	# TODO: insert more data types here and increase e_prop_type_resource

	e_prop_type_resource = 4,

	e_prop_types_count
}

# Data filters
enum {
	e_data_filter_equal = 0,
	e_data_filter_not_equal = 1,
	e_data_filter_less = 2,
	e_data_filter_greater = 3,
	e_data_filter_lequal = 4, # less or equal
	e_data_filter_gequal = 5 # greater or equal
}

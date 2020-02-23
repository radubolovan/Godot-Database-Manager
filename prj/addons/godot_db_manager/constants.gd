tool
extends Node

# characters that should not be part of the database name
const c_invalid_characters = "`~!@#$%^&*()=+[]{}\\|;:'\",<.>/?"

# checks the name of the database
func check_db_name(name : String) -> bool :
	for idx in range(0, name.length()):
		for jdx in range(0, g_constants.c_invalid_characters.length()):
			if(name[idx] == g_constants.c_invalid_characters[jdx]):
				return false
	return true

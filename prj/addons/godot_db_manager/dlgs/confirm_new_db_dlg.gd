tool
extends AcceptDialog

signal confirm_new_database

func _ready():
	add_cancel("Cancel")

func on_accept():
	emit_signal("confirm_new_database")


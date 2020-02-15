tool
extends AcceptDialog

signal confirm_new_database

func _ready():
	add_cancel("Cancel")
	connect("confirmed", self, "on_confirmed")

func on_confirmed():
	emit_signal("confirm_new_database")

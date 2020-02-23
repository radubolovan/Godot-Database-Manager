tool
extends Control

func _ready():
	$tables_header.connect("add_table", self, "on_add_table")

func on_add_table():
	print("on_add_table")

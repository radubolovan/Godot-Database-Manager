"""
class GDDBTablesHeader
"""

class_name GDDBTablesHeader

tool
extends Control

signal add_table

# Called when the node enters the scene tree for the first time.
func _ready():
	$add_table_btn.connect("pressed", self, "on_add_table_btn_pressed")

func on_add_table_btn_pressed():
	emit_signal("add_table")

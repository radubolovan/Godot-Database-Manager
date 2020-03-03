"""
class GDDBGlobals
"""

class_name GDDBGlobals

tool
extends Node

var m_global_dlg = null

func set_global_dlg(dlg : Object) -> void:
	m_global_dlg = dlg

func get_global_dlg() -> Object:
	return m_global_dlg

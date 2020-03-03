"""
class GDDBOptionsList
"""

class_name GDDBOptionsList

tool
extends PopupPanel

class cOption:
	var m_option_id : int = g_constants.c_invalid_id
	var m_option_text

var m_options = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_option(option_id, option_text):
	var option = cOption.new()
	option.m_option_id = option_id
	option.m_option_text = option_text
	m_options.push_back(option)

func popup(bounds: Rect2 = Rect2( 0, 0, 0, 0 )):
	for idx in range(0, m_options.size()):
		var opt = load(g_constants.c_addon_main_path + "db_combo_option.tscn").instance()
		$Container/v_layout.add_child(opt)
		opt.set_option_id(m_options[idx].m_option_id)
		opt.set_option_text(m_options[idx].m_option_text)
		opt.connect("selected", self, "on_select_option")
	.popup(bounds)

func on_select_option(option_id):
	print(str(option_id) + " was selected")
	hide()

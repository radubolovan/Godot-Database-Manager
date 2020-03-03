"""
class GDDBComboBox
"""

class_name GDDBComboBox

tool
extends TextureButton

signal about_to_show
signal option_selected

var m_current_option_idx : int = g_constants.c_invalid_id
var m_show_options : bool = false

var m_options = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")

	$normal.show()
	$hover.hide()

	m_options = load(g_constants.c_addon_main_path + "options_list.tscn").instance()
	g_globals.get_global_dlg().add_child(m_options)

	var rect = get_global_rect()
	var pos = rect.position + Vector2(0.0, rect.size.y) - g_globals.get_global_dlg().get_global_rect().position
	m_options.set_position(pos)

# adds an option
func add_option(option_id: int, option_text : String) -> void:
	m_options.add_option(option_id, option_text)

# selects the current option
func set_selected_option(option_idx : int) -> void:
	# print("GDDBComboBox::set_selected_option(" + str(option_idx) + ")")
	for idx in range(0, m_options.get_child(0).get_child_count()):
		m_options.get_child(0).get_child(idx).set_selected(false)
	m_options.get_child(0).get_child(option_idx).set_selected(true)
	$text.set_text(m_options.get_child(0).get_child(option_idx).get_text())
	m_current_option_idx = option_idx

# returns current option
func get_current_option() -> int:
	return m_current_option_idx

# returns current option name
func get_current_option_name() -> String:
	if(m_current_option_idx == g_constants.c_invalid_id || m_options.get_child(0).get_child_count() == 0):
		return ""
	return m_options.get_child(0).get_child(m_current_option_idx).get_text()

# removes all options
func remove_all_options() -> void :
	for idx in range(m_options.get_child(0).get_child_count()-1, -1, -1):
		m_options.get_child(0).remove_child(m_options.get_child(0).get_child(idx))

# Called when the mouse enters the control’s Rect area
func on_mouse_entered() -> void:
	$normal.hide()
	$hover.show()

# Called when the mouse leaves the control’s Rect area
func on_mouse_exited() -> void:
	$normal.show()
	$hover.hide()

# Called when button is pressed
func on_pressed() -> void:
	if(m_show_options):
		m_show_options = false
		m_options.hide()
	else:
		emit_signal("about_to_show")
		m_show_options = true
		m_options.show()

# Called when selectin an option
func on_selct_option(option_id : int) -> void:
	print("GDDBComboBox::on_selct_option(" + str(option_id) + ")")
	var option_idx = -1
	for idx in range(0, m_options.get_child(0).get_child_count()):
		var opt = m_options.get_child(0).get_child(idx)
		if(opt.get_option_id() == option_id):
			option_idx = idx
			break
	set_selected_option(option_idx)
	m_show_options = false
	#$options.hide()
	m_options.hide()
	emit_signal("option_selected", option_id)

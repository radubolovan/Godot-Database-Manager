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
var m_option_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")

	$normal.show()
	$hover.hide()
	$options.hide()

# adds an option
func add_option(option_id: int, option_text : String) -> void:
	var opt = load(g_constants.c_addon_main_path + "db_combo_option.tscn").instance()
	$options/layout.add_child(opt)
	m_option_list.push_back(opt)

	# print("GDDBComboBox::add_option(" + str(option_id) + ", " + option_text + ")")

	opt.set_option_id(option_id)
	opt.set_text(option_text)
	opt.connect("selected", self, "on_selct_option")

	var option_size = opt.get_size()

	var size = Vector2(option_size.x, ($options/layout.get_child_count() + 1) * option_size.y)
	$options.set_size(size)

# selects the current option
func set_selected_option(option_idx : int) -> void:
	# print("GDDBComboBox::set_selected_option(" + str(option_idx) + ")")
	for idx in range(0, $options/layout.get_child_count()):
		$options/layout.get_child(idx).set_selected(false)
	$options/layout.get_child(option_idx).set_selected(true)
	$text.set_text($options/layout.get_child(option_idx).get_text())
	m_current_option_idx = option_idx

# returns current option
func get_current_option() -> int:
	return m_current_option_idx

# returns current option name
func get_current_option_name() -> String:
	if(m_current_option_idx == g_constants.c_invalid_id || $options/layout.get_child_count() == 0):
		return ""
	return $options/layout.get_child(m_current_option_idx).get_text()

# removes all options
func remove_all_options() -> void :
	for idx in range($options/layout.get_child_count()-1, -1, -1):
		$options/layout.remove_child($options/layout.get_child(idx))

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
		$options.hide()
	else:
		emit_signal("about_to_show")
		m_show_options = true
		$options.show()

# Called when selectin an option
func on_selct_option(option_id : int) -> void:
	print("GDDBComboBox::on_selct_option(" + str(option_id) + ")")
	var option_idx = -1
	for idx in range(0, $options/layout.get_child_count()):
		var opt = $options/layout.get_child(idx)
		if(opt.get_option_id() == option_id):
			option_idx = idx
			break
	set_selected_option(option_idx)
	m_show_options = false
	$options.hide()
	emit_signal("option_selected", option_id)

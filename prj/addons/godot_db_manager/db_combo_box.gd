"""
class GDDBComboBox
"""

class_name GDDBComboBox

tool
extends TextureButton

var m_current_option : int = g_constants.c_invalid_id
var m_show_options : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")

	$normal.show()
	$hover.hide()
	$options.hide()

# adds an option
func add_option(text : String) -> void:
	var option_id = $options/layout.get_child_count()
	var opt = load(g_constants.c_addon_main_path + "db_combo_option.tscn").instance()
	$options/layout.add_child(opt)

	opt.set_option_id(option_id)
	opt.set_text(text)
	opt.connect("selected", self, "on_selct_option")

	var option_size = opt.get_size()

	var size = Vector2(option_size.x, ($options/layout.get_child_count() + 1) * option_size.y)
	$options.set_size(size)

# selects the current option
func set_selected_option(option_id : int) -> void:
	for idx in range(0, $options/layout.get_child_count()):
		var option = $options/layout.get_child(idx)
		if(option.get_option_id() == option_id):
			option.set_selected(true)
			$text.set_text(option.get_text())
		else:
			option.set_selected(false)

# removes all options
func remove_all_options() -> void :
	for idx in range(0, $options/layout.get_child_count()):
		$options/layout.get_child(idx).queue_free()

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
		m_show_options = true
		$options.show()

# Called when selectin an option
func on_selct_option(option_id : int) -> void:
	set_selected_option(option_id)
	m_show_options = false
	$options.hide()

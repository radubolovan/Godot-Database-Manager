extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_tex(tex_path : String) -> void:
	$tex_holder/tex.texture = load(tex_path).duplicate()

func set_res_name(res_name : String) -> void:
	$name.set_text(res_name)

func set_amount(amount : int) -> void:
	$amount.set_text(str(amount))

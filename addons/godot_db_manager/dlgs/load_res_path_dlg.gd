"""
class GDDBLoadResourcePathDlg
"""

class_name GDDBLoadResourcePathDlg

tool
extends FileDialog

# TODO: put this list in a config file
const file_filters = [
	# Godot resource file types
	"*.res, *.tres ; Godot resource file types",

	# Godot scene files
	"*.scn, *.tscn, *escn ; Godot scene file types",

	# Code file types
	"*.gd, *.cs, *.h, *.c, *.hpp, *.cpp ; Code file types",

	# Shader file types
	"*.shader ; Shader file types",

	# material file types
	"*.mat ; Material file types",

	# mesh file types
	"*.dae, *.gltf, *.obj, *.fbx ; Mesh file types",

	# animation file types
	"*.anim ; Animation file types",

	# font file types
	"*.ttf, *.otf ; Font file types",

	# image file types
	"*.png, *.jpg, *.jpeg, *.tiff, *.tga, *.bmp, *.webp, *.gif, *.hdr ; Images file types",

	# soung file types
	"*.snd, *.wav, *.ogg, *.mp3 ; Sound file types",

	# video file types
	"*.ogg, *.mpg, *.mpeg, *.avi, *.mov, *.mp4, *.webm ; Video file types",

	# text file types
	"*.txt, *.csv, *.json, *.xml, *.cfg, *.ini ; Text file types",

	# document file types
	"*.doc, *.docx, *.xls, *.xlsx, *.odt, *.ods, *.pdf ; Doc file types",
	
	# binary data file types
	"*.dat, *.raw ; Binary data file types"
]

var m_prop_id = gddb_constants.c_invalid_id
var m_row_idx = gddb_constants.c_invalid_id

# Called when the node enters the scene tree for the first time.
func _ready():
	set_filters(PoolStringArray(file_filters))

# sets the property id
func set_prop_id(prop_id : int) -> void :
	m_prop_id = prop_id

# returns the property id
func get_prop_id() -> int :
	return m_prop_id

# sets the row index
func set_row_idx(row_idx : int) -> void :
	m_row_idx = row_idx

# returns the row index
func get_row_idx() -> int :
	return m_row_idx

"""
class GDDBLoadResourcePathDlg
"""

class_name GDDBLoadResourcePathDlg

tool
extends FileDialog

# TODO: put this list in a config file
const file_filters = [
	# general Godot resource file types
	"*.res ; RES files",
	"*.tres ; TRES files",

	# font file types
	"*.ttf ; TTF files",
	"*.otf ; TTF files",

	# image file types
	"*.png ; PNG files",
	"*.jpg ; JPEG files",
	"*.jpeg ; JPEG files",
	"*.tiff ; TIFF files",
	"*.tga ; TGA files",
	"*.bmp ; BMP files",
	"*.webp ; WebP files",
	"*.gif ; GIF files",
	"*.hdr ; HDR files",

	# soung file types
	"*.wav ; WAV files",
	"*.ogg ; OGG files",
	"*.mp3 ; MP3 files",
	"*.raw ; MP3 files",

	# video file types
	"*.mpg ; MPEG files",
	"*.mpeg ; MPEG files",
	"*.avi ; AVI files",
	"*.mov ; MOV files",
	"*.mp4 ; MP4 files",
	"*.webm ; WebM files"
]

var m_prop_id = g_constants.c_invalid_id
var m_row_idx = g_constants.c_invalid_id

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

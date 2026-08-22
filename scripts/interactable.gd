class_name Interactable
extends Node3D

## World click target. Combat uses a different collision layer.

@export var click_sound: AudioStream
@export var pitch_scale: float = 1.0
@export var react_on_click: bool = false

@onready var _player: AudioStreamPlayer = $AudioStreamPlayer

var _did_react: bool = false


func _ready() -> void:
	if click_sound == null:
		click_sound = AudioStreamWAV.load_from_file("res://assets/sfx/click.wav")
	if click_sound == null:
		click_sound = _make_beep()
	if _player != null:
		_player.stream = click_sound
		_player.pitch_scale = pitch_scale


func interact() -> void:
	if _player == null:
		push_error("Interactable missing AudioStreamPlayer")
		return
	if _player.stream == null:
		_player.stream = click_sound
	if _player.stream == null:
		push_error("Interactable missing click_sound")
		return
	_player.pitch_scale = pitch_scale
	_player.play()
	_react_if_needed()


func _react_if_needed() -> void:
	if not react_on_click or _did_react:
		return
	_did_react = true
	var mesh := get_node_or_null("Mesh") as MeshInstance3D
	if mesh == null:
		return
	mesh.rotate_z(0.5)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(0.28, 0.24, 0.12, 1.0)
	mesh.set_surface_override_material(0, mat)


func _make_beep() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.stereo = false
	var sample_count: int = int(22050.0 * 0.18)
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for i: int in sample_count:
		var t: float = float(i) / 22050.0
		var env: float = maxf(0.0, 1.0 - t / 0.18)
		var sample: int = int(18000.0 * env * sin(TAU * 880.0 * t))
		data.encode_s16(i * 2, clampi(sample, -32768, 32767))
	stream.data = data
	return stream

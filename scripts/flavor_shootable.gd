class_name FlavorShootable
extends Node3D

## World prop that reacts to tank shoot hitscan (audio + one-time tilt).

@export var click_sound: AudioStream
@export var react_on_click: bool = true
## When set, replaces the packed-in Visual (default barrel) with this mesh scene.
@export var prop_mesh: PackedScene

@onready var _player: AudioStreamPlayer = $AudioStreamPlayer

var _did_react: bool = false


func _ready() -> void:
	_apply_prop_mesh()
	if click_sound == null:
		click_sound = AudioStreamWAV.load_from_file("res://assets/sfx/click.wav")
	if click_sound == null:
		click_sound = _make_beep()
	if _player != null:
		_player.stream = click_sound


func _apply_prop_mesh() -> void:
	if prop_mesh == null:
		return
	var old := get_node_or_null("Visual")
	if old != null:
		remove_child(old)
		old.free()
	var visual := prop_mesh.instantiate() as Node3D
	if visual == null:
		push_error("FlavorShootable prop_mesh must root as Node3D")
		return
	visual.name = "Visual"
	visual.scale = Vector3(100.0, 100.0, 100.0)
	add_child(visual)
	move_child(visual, 0)


func take_shot() -> void:
	if _did_react:
		return
	_did_react = true
	_play_click()
	_apply_visual_react()


func _play_click() -> void:
	if _player == null:
		push_error("FlavorShootable missing AudioStreamPlayer")
		return
	if _player.stream == null:
		_player.stream = click_sound
	if _player.stream == null:
		push_error("FlavorShootable missing click_sound")
		return
	_player.play()


func _apply_visual_react() -> void:
	if not react_on_click:
		return
	var visual := get_node_or_null("Visual") as Node3D
	if visual == null:
		return
	visual.rotate_z(0.4)


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
		var sample: int = int(18000.0 * env * sin(TAU * 660.0 * t))
		data.encode_s16(i * 2, clampi(sample, -32768, 32767))
	stream.data = data
	return stream

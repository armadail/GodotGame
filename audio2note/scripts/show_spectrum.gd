extends Node2D


const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 800
const HEIGHT = 500

const MIN_DB = 60

var spectrum


# my own variables
const notes = 59 #107 # total number of notes from C0 to B8
const a440ref = 33 # 57
const c = 2 ** (1/12.0) # one semitone up is note freq * c

var keyboard = []

var notelabels = ""
var num2note = {
	0:"C",
	1:"C#",
	2:"D",
	3:"D#",
	4:"E",
	5:"F",
	6:"F#",
	7:"G",
	8:"G#",
	9:"A",
	10:"A#",
	11:"B"
	}
	
	


func spawn_note(i:int, duration:float):
	# duraction 1: quarter note 2: half note 4: whole note etc...
	
	var new_note = preload("res://notebox.tscn").instantiate()
	%PathFollow2D.progress_ratio = float(i)/notes
	new_note.global_position = %PathFollow2D.global_position
	new_note.scale = Vector2(0.5, duration)
	add_child(new_note)
	keyboard.append(new_note)
	
	notelabels = notelabels + num2note[i % 12] + str(i / 12) + " "
	


func update_note(i:int, strength:float):
	keyboard[i].scale = Vector2(0.5,strength)
	
	
	
	
func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	
	for i in range(0, notes):
		spawn_note(i,1)
	
	%KeyboardText.set_text(notelabels)
	



func _process(_delta):
	queue_redraw()


var max_energy = 0
var max_i = 0
	
func _draw():
	

	
	var w = WIDTH / notes
	var prev_hz = 440 * 2 ** ((-0.5 - a440ref)/12) # frequency of C0(flat)
	
	max_energy = 0
	max_i = 0
	
	for i in range(0, notes):
		var hz = prev_hz * c
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		
		if energy > max_energy:
			max_energy = energy
			max_i = i
		#update_note(i,energy)
		#draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.WHITE)
		prev_hz = hz 
	
		
	







#
#func _on_timer_timeout():
	#spawn_note(max_i, max_energy)


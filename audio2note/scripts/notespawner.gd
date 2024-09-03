extends CharacterBody2D

var spectrum 

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	

func updateposition(i):
	const dampingfactor = 3 #how fast the character moves to the target note
	global_position.y
	velocity = (Vector2(i*10,50) -  global_position) * dampingfactor
	move_and_slide()


const WIDTH = 800

const MIN_DB = 60


# my own variables
const notes = 59 #107 # total number of notes from C0 to B8 59
const a440ref = 33 # 57 33 
const c = 2 ** (1/12.0) # one semitone up is note freq * c

var max_energy = 0
var max_i = 0
const noise_threshold = 0.1


func _process(_delta):

	var w = WIDTH / notes
	var prev_hz = 440 * 2 ** ((-0.5 - a440ref)/12) # frequency of C0(flat)
	
	max_energy = 0
	max_i = 0
	
	for i in range(0, notes):
		var hz = prev_hz * c
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		
		# calculate the peak of the frequency spectrum
		if energy > max_energy:
			max_energy = energy
			max_i = i
		
		prev_hz = hz 
		
	if(max_energy > noise_threshold):
		# dont need to update the position if theres no audio
		updateposition(max_i)
	


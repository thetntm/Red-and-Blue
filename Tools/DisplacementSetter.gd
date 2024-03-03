class_name DisplacementSetter extends Node2D

@export var use_noise = false;

@export var value : Vector2 = Vector2(0,0);
@onready var prev_value = value;

@export var noise : Noise;

var noise_value = Vector2(0,0);

var distortion = Vector2(0,0);

const noise_effect = 4.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.global_shader_parameter_set("displacement",value);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if use_noise:
		noise_value.x += delta;
		noise_value.y += delta;
		distortion = (Vector2(noise.get_noise_2d(noise_value.x,0.0) - 0.5,noise.get_noise_2d(noise_value.y,2.0) - 0.5) * noise_effect)
		updateDisplacement()
	elif value != prev_value:
		updateDisplacement();
	
func setDisplacement(v = value):
	value = v;
	updateDisplacement();

func updateDisplacement():
	if use_noise:
		RenderingServer.global_shader_parameter_set("displacement",value + distortion);
	else:
		RenderingServer.global_shader_parameter_set("displacement",value);
	prev_value = value;

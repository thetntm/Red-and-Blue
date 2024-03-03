extends Area2D

@export var rotNoise : Noise;
@export var scaleNoise : Noise;

@onready var sprite : Sprite2D = $CanvasGroup/Objects7;

var clock = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock += delta;
	var noiseValue = rotNoise.get_noise_1d(clock);
	sprite.rotation = noiseValue * 4 * PI - 2 * PI;
	var scaleValue = scaleNoise.get_noise_1d(clock);
	scaleValue = 1.0 + scaleValue * 0.5 - 0.25;
	sprite.scale = Vector2(scaleValue,scaleValue);

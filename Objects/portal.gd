extends Area2D

@export var rotNoise : Noise;
@export var scaleNoise : Noise;

var playerReference : Player;
var playerInPortal = false;

@export_enum("all","none","Red","Blue") var mode = 0;

@onready var sprite : Sprite2D = $sprite;

var clock = 0.0;

signal portal_entered;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock += delta;
	var noiseValue = rotNoise.get_noise_1d(clock);
	sprite.rotation = noiseValue * 4 * PI - 2 * PI;
	var scaleValue = scaleNoise.get_noise_1d(clock) * 3.0 + 1.5;
	scaleValue = 1.0 + scaleValue * 0.5 - 0.25;
	sprite.scale = Vector2(scaleValue,scaleValue);
	if playerInPortal:
		compareModes();
		
func compareModes():
	if playerReference.currentMode == mode || mode == 0:
		emit_signal("portal_entered");
		playerReference.state = -1; #force the player to do nothing
		playerReference.velocity = Vector2.ZERO;
		playerReference.blueSprite.hide();
		playerReference.redSprite.hide();

func _on_body_entered(body):
	if body is Player:
		playerInPortal = true;
		playerReference = body;
		compareModes();


func _on_body_exited(body):
	if body is Player:
		playerInPortal = false;

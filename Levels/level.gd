class_name Level extends Node2D

signal level_started;
signal level_ended(level);

@onready var player = $Player;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is LevelLoader:
		player.state = -1; #freeze the player until the level starts;
	else:
		start();
	#comment this out when running from loader

func start():
	player.state = player.states.IDLE;
	emit_signal("level_started");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func endLevel():
	emit_signal("level_ended",self);

func _on_end_portal_body_entered(body):
	if body is Player:
		body.state = -1; #force the player to do nothing
		body.velocity = Vector2.ZERO;
		body.blueSprite.hide();
		body.redSprite.hide();
		endLevel();

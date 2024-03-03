extends Node2D

var playerInSpike = false;

var player : Player;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func checkMode():
	if player.currentMode == player.modes.BLUE:
		player.die();
		playerInSpike = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerInSpike:
		checkMode();

func object_entered(node):
	if node is Player:
		player = node;
		playerInSpike = true;
		checkMode();

func object_exited(node):
	if node is Player:
		playerInSpike = false;

extends Node

@export var player : Player;
@export var portal : Node2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func movePortal():
	portal.position = Vector2(player.position.x + 280,portal.position.y);

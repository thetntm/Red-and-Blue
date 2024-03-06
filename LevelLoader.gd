class_name LevelLoader extends Control

@export var levels: Array[PackedScene];

@onready var dj : DJ = $Dj;

@onready var transitions : AnimationPlayer = $CanvasLayer/Transitions;

@onready var subview : SubViewport = $SubViewport;

var currentLevel = 0;

var levelReference : Level;

# Called when the node enters the scene tree for the first time.
func _ready():
	levelReference = levels[currentLevel].instantiate();
	subview.add_child(levelReference);
	levelReference.level_ended.connect(_on_level_ended);
	startLevel();
	pass # Replace with function body.

func loadCurrentLevel():
	levelReference = levels[currentLevel].instantiate()
	subview.add_child(levelReference);
	levelReference.level_ended.connect(_on_level_ended);
	transitions.play("ReverseSweep");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_ended(level):
	levelReference = level;
	transitions.play("DiagonalSweep");


func clearLevel():
	levelReference.queue_free();
	currentLevel += 1;
	if currentLevel < levels.size():
		loadCurrentLevel();
		
func startLevel():
	levelReference.start();

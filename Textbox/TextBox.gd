class_name Textbox extends Control

@export_multiline var textLines : Array[String];

var label : Label;

var noise : AudioStreamPlayer;

var currentLine : int = 0;

var charSpeed = 1.0 / 21.0;

var clock = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $TextureRect/Label;
	noise = $Noise;
	#delete this before using
	beginTextBox();
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if label.visible_ratio < 1.0:
			label.visible_ratio = 1.0;
		else:
			goToNextLine();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	clock += delta;
	if label.visible_ratio < 1.0:
		#use a while loop so that it can display more than one character in the span of a single frame
		while clock >= charSpeed:
			label.visible_characters+=1;
			clock -= charSpeed;
			if clock < charSpeed && !label.text[label.visible_characters-1].contains(" "):
				noise.play();

func beginTextBox(line = 0):
	currentLine = line;
	label.set_text(textLines[currentLine]);
	label.visible_characters = 0;
	
func goToNextLine():
	currentLine += 1;
	if !(currentLine >= textLines.size()):
		label.set_text(textLines[currentLine]);
		label.visible_characters = 0;
		clock = 0.0;
	else:
		closeTextBox();

func closeTextBox():
	queue_free();

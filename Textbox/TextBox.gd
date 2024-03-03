class_name Textbox extends Control

@export_multiline var textLines : Array[String];

@export var charSprites: Array[Texture2D];

@onready var label : Label = $Label;

@onready var noise : AudioStreamPlayer = $Noise;

@onready var background : NinePatchRect = $NinePatchRect;

@onready var pfp : TextureRect = $pfp;

var currentLine : int = 0;

var charSpeed = 1.0 / 21.0;

const animSpeed = 0.25;

var animClock = animSpeed;

var clock = 0.0;

var frame = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pfp.texture = charSprites[frame];
	label = $Label;
	noise = $Noise;
	hide();

func _input(event):
	if Input.is_action_just_pressed("TextBoxAdvance") && visible:
		if label.visible_ratio < 1.0:
			label.visible_ratio = 1.0;
		else:
			goToNextLine();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if visible:
		clock += delta;
		if label.visible_ratio < 1.0:
			#use a while loop so that it can display more than one character in the span of a single frame
			while clock >= charSpeed:
				label.visible_characters+=1;
				clock -= charSpeed;
				if clock < charSpeed && !label.text[label.visible_characters-1].contains(" "):
					noise.play();
			animClock -= delta;
			if animClock <= 0:
				animClock = animSpeed;
				frame += 1;
				frame %= charSprites.size();
				pfp.texture = charSprites[frame];
		else:
			pfp.texture = charSprites[0];

func beginTextBox(line = 0):
	clock = 0.0;
	frame = 0;
	show();
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
	var parent = get_parent();
	if parent is TextBoxChain:
		parent.nextTextBox();
	queue_free();

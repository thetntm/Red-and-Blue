class_name TextBoxChain extends Control

@export var textBoxes : Array[Textbox];

signal finished;

var currentBox = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func openBox():
	textBoxes[currentBox].beginTextBox();
	currentBox += 1;

func begin():
	show();
	openBox();

func nextTextBox():
	if currentBox >= textBoxes.size():
		emit_signal("finished")
		queue_free();
	else:
		openBox();

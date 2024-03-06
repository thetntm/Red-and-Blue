class_name TextBoxChain extends Control

@export var textBoxes : Array[Textbox];

signal finished;

signal started;

var currentBox = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	currentBox = 0;
	pass

func openBox():
	textBoxes[currentBox].beginTextBox();
	currentBox += 1;

func begin():
	emit_signal("started");
	currentBox = 0; #something is wrong only sometimes and I have no
	show();
	openBox();

func nextTextBox():
	if currentBox >= textBoxes.size():
		emit_signal("finished")
		queue_free();
	else:
		openBox();

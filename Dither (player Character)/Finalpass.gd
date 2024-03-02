class_name FinalPass extends ColorRect

enum modes {NIL,PLAYER,RED,BLUE,ALL};

var mode = modes.NIL;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	(material as ShaderMaterial).set_shader_parameter("mode", mode);
	pass

extends Area2D

signal trigger;

var triggered = false;

func _on_body_entered(body):
	if body is Player and not triggered:
		emit_signal("trigger");
		triggered = true;

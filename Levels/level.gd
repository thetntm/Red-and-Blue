class_name Level extends Node2D

signal level_started;
signal level_ended(level);

@onready var player = $Player;

@onready var loader = get_parent().get_parent();

@onready var dj : DJ;

var firstProcess = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	if loader is LevelLoader:
		player.state = -1; #freeze the player until the level starts;
		dj = loader.dj;
	else:
		start();
	#comment this out when running from loader

func start():
	player.state = player.states.IDLE;
	emit_signal("level_started");

func player_reached_portal():
	emit_signal("level_ended",self);

#I really, really hate that I couldn't find a better way to do this.
#Seriously sorry to anyone reading this code.
#If you think of a better way please dm me and explain how to do it.
func play_all():
	if dj:
		dj.play_all();
	
func fade_in_drums():
	if dj:
		dj.fade_in_drums();
	
func fade_out_drums():
	if dj:
		dj.fade_out_drums();

func fade_in_bass():
	if dj:
		dj.fade_in_bass();
	
func fade_out_bass():
	if dj:
		dj.fade_in_bass();

func fade_in_bells():
	if dj:
		dj.fade_in_bells();
	
func fade_out_bells():
	if dj:
		dj.fade_out_bells();

func fade_in_chords():
	if dj:
		dj.fade_in_chords();
	
func fade_out_chords():
	if dj:
		dj.fade_out_chords();
	
func fade_out_all():
	if dj:
		dj.fade_out_all();

func start_drums():
	if dj:
		dj.start_drums();

func start_bass():
	if dj:
		dj.start_bass();

func start_bells():
	if dj:
		dj.start_bells();

func start_chords():
	if dj:
		dj.start_chords();

func start_all():
	if dj:
		dj.start_all();

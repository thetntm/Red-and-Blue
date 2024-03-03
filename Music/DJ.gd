class_name DJ extends Node

var amen : AudioStreamPlayer;
var bass : AudioStreamPlayer;
var bells : AudioStreamPlayer;
var chords : AudioStreamPlayer;

#faders: array of TARGET values given a lerp of -72 to 0 db. 0 = silent, 1 = full volume. keep in mind this scales at a curve because DB is weird.
var fader_target : Array[float] = [0.0,0.0,0.0,0.0];
#Current progress of each lerp for the faders.
var fader_lerpProgress : Array[float] = [0.0,0.0,0.0,0.0];
#previous value of all faders, to be used as the starting point lerp target
var fader_previous : Array[float] = [0.0,0.0,0.0,0.0];
#the true array of what each fader is actually at. scales the same as faders.
var fader : Array[float] = [0.0,0.0,0.0,0.0];

#Start at 0.
#Fader target has changed!
#ramp up the fader target from previous value to next value in fadespeed seconds.
#in other words, lerp that value from 
#
var fadeSpeed = 4.0; #speed to fade in seconds.

# Called when the node enters the scene tree for the first time.
func _ready():
	amen = $Amen;
	bass = $Bass;
	bells = $Bells;
	chords = $Chords;
	set_all_channels_to_zero();
	play_all();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !fader == fader_target:
		for i in 4:
			fader_lerpProgress[i] += delta/fadeSpeed;
			if fader_target[i] >= fader_previous[i]:
				fader[i] = clampf(lerpf(fader_previous[i],fader_target[i],fader_lerpProgress[i]),0.0,fader_target[i]);
			else:
				fader[i] = clampf(lerpf(fader_previous[i],fader_target[i],fader_lerpProgress[i]),fader_target[i],1.0);
			AudioServer.set_bus_volume_db(i+3,lerpf(-72.0,0.0,fader[i]));

func set_fade(channel,fadeAmount):
	fadeAmount = clampf(fadeAmount,0.0,1.0); #for SAFETY in case someone (ME) forgets how this works and tries to set this to a number greater than 1
	fader_lerpProgress[channel] = 0.0;
	fader_target[channel] = fadeAmount;
	fader_previous[channel] = fader[channel];

#Jump straight to the set amount, rather than smoothly ramping up to it.
func set_fade_manual(channel,fadeAmount):
	fadeAmount = clampf(fadeAmount,0.0,1.0);
	fader_lerpProgress[channel] = 1.0;
	fader_target[channel] = fadeAmount;
	fader_previous[channel] = fader[channel];
	fader[channel] = fadeAmount;
	AudioServer.set_bus_volume_db(channel+3,lerpf(-72.0,0.0,fader[channel]));

func restart_all_channels():
	#amen.stop()
	#bass.stop()
	#bells.stop()
	#chords.stop()
	amen.play()
	bass.play()
	bells.play()
	chords.play()

func set_all_channels_to_zero():
	AudioServer.set_bus_volume_db(3,-72.0);
	AudioServer.set_bus_volume_db(4,-72.0);
	AudioServer.set_bus_volume_db(5,-72.0);
	AudioServer.set_bus_volume_db(6,-72.0);

func play_all():
	amen.play()
	bass.play()
	bells.play()
	chords.play()
	
func fade_in_drums():
	set_fade(0,1.0)
	
func fade_out_drums():
	set_fade(0,0.0)

func fade_in_bass():
	set_fade(1,1.0)
	
func fade_out_bass():
	set_fade(1,0.0)

func fade_in_bells():
	set_fade(2,1.0)
	
func fade_out_bells():
	set_fade(2,0.0)

func fade_in_chords():
	set_fade(3,1.0)
	
func fade_out_chords():
	set_fade(3,0.0)
	
func fade_out_all():
	fade_out_bass()
	fade_out_drums()
	fade_out_chords()
	fade_out_bells()

func start_drums():
	set_fade_manual(0,1.0);
	restart_all_channels();

func start_bass():
	set_fade_manual(1,1.0);
	restart_all_channels();

func start_bells():
	set_fade_manual(2,1.0);
	restart_all_channels();

func start_chords():
	set_fade_manual(3,1.0);
	restart_all_channels();

func start_all():
	start_drums()
	start_bass()
	start_bells()
	start_chords()

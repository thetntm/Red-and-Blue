class_name Player extends CharacterBody2D

enum states {IDLE,WALKING,JUMPING,FALLING,DYING};

@onready var animator : AnimationPlayer = $CharacterAnimator;
@onready var blueSprite : Sprite2D = $blueshade/blueSprite;
@onready var redSprite : Sprite2D = $redshade/redSprite;
@onready var finalPassShader : FinalPass = $Camera2D/Finalpass;
@onready var redRay : RayCast2D = $RedRayCast;
@onready var blueRay : RayCast2D = $BlueRayCast;

@onready var warpSound1 : AudioStreamPlayer = $WarpSound1
@onready var warpSound2 : AudioStreamPlayer = $WarpSound2
@onready var noShift : AudioStreamPlayer = $youCant;

var state = states.IDLE;

var acceptingInput = true;

#This math is from the video "making a jump you can actually use in godot" courtesy of Pefeper. Check out their video on it, the rest of the code for actually using these variables is mine.
#@export var jump_height : float
#@export var jump_time_to_peak : float
#@export var jump_time_to_descent : float

#@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
#@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
#@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

const TOPSPEED = 140.0;
const ACCEL = TOPSPEED * 7.5; #it's high because it's gonna be scaled for delta time, TRUST ME.
const AIRACCEL = ACCEL / 2.0;
const JUMP_VELOCITY = -400.0 * 0.58;
const jump_gravity = 980 / 2.5;
const fall_gravity = 980 / 1.2;

@export var use_pause_ahead = false;

@export var shiftUnlocked = true;

@export var jumpUnlocked = true;

@onready var startingPoint : Vector2 = position;

var useJumpGravity : bool = false;

var shiftCooldown = 0.0;
#why the fuck do collisions start at 1 what the fuck is wrong with you godot

enum modes {NIL,GODOTISSTUPIDSOMETIMES,RED,BLUE,ALL}

var currentMode = modes.RED;

func _ready():
	animator.play("Idle")
	set_collision();
	#set_collision_mask_value(currentMode,true);


func set_collision():
	set_collision_mask_value(modes.ALL,false);
	set_collision_mask_value(modes.RED,false);
	set_collision_mask_value(modes.BLUE,false);
	set_collision_mask_value(currentMode,true);
	finalPassShader.mode = currentMode;
	
func resetShiftCooldown():
	shiftCooldown = 0.4;

func _process(delta):
	shiftCooldown = clampf(shiftCooldown - delta,0.0,2.0);


func _physics_process(delta):
	#Get the direction:
	if Input.is_action_just_pressed("Shift") && acceptingInput:
		if shiftCooldown == 0.0:
			shift();
	var direction = Input.get_axis("Left", "Right")
	if !acceptingInput:
		direction = 0;
	stateMachine(direction,delta);
	move_and_slide()

func shift():
	resetShiftCooldown();
	if shiftUnlocked:
		if currentMode == modes.RED:
			if !blueRay.is_colliding():
				currentMode = modes.BLUE;
				set_collision();
				warpSound2.play();
			else:
				noShift.play();
				if state == states.IDLE:
					animator.play("NoShiftIdle");
				elif !is_on_floor():
					animator.play("NoShiftAir");
		elif currentMode == modes.BLUE:
			if !redRay.is_colliding():
				currentMode = modes.RED;
				set_collision();
				warpSound1.play();
			else:
				noShift.play();
				if state == states.IDLE:
					animator.play("NoShiftIdle");
				elif !is_on_floor():
					animator.play("NoShiftAir");
		else:
			currentMode = modes.ALL;
			set_collision();

func disable():
	acceptingInput = false;

func enable():
	acceptingInput = true;

func updateState(newState):
	state = newState;
	updateAnimation();

func updateAnimation():
	match state:
		states.IDLE:
			animator.play("Idle")
		states.WALKING:
			animator.play("Run");
		states.JUMPING:
			useJumpGravity = true;
			animator.play("Jump")
		states.FALLING:
			useJumpGravity = false;
			animator.play("Fall");

func respawn():
	position = startingPoint;
	state = states.IDLE;
	updateAnimation();
	acceptingInput = true;

func die():
	velocity = Vector2(0,0);
	animator.play("Death")
	state = states.DYING;
	acceptingInput = false;

func fall(gravity, delta):
	if checkForPauseAhead():
		gravity = 0;
	velocity.y += gravity * delta

func checkForPauseAhead():
	if !is_on_floor() && use_pause_ahead && currentMode == modes.BLUE:
		return true;
	return false;

func stateMachine(direction,delta):
	match state:
		states.IDLE:
			if direction:
				velocity.x = clampf(velocity.x + direction * ACCEL * delta,-TOPSPEED,TOPSPEED)
				redSprite.flip_h = sign(velocity.x) - 1;
				blueSprite.flip_h = sign(velocity.x) - 1;
				updateState(states.WALKING);
			else:
				velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
			if Input.is_action_just_pressed("Jump") && jumpUnlocked and is_on_floor() && acceptingInput:
				velocity.y = JUMP_VELOCITY
				updateState(states.JUMPING);
			if not is_on_floor(): #why wouldn't you be??????
				fall(fall_gravity,delta);
				updateState(states.FALLING)
		states.WALKING:
			if direction:
				velocity.x = clampf(velocity.x + direction * ACCEL * delta,-TOPSPEED,TOPSPEED)
				redSprite.flip_h = sign(velocity.x) - 1;
				blueSprite.flip_h = sign(velocity.x) - 1;
			else:
				updateState(states.IDLE);
				velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
			if Input.is_action_just_pressed("Jump") && jumpUnlocked and is_on_floor() and acceptingInput:
				velocity.y = JUMP_VELOCITY
				updateState(states.JUMPING);
			if not is_on_floor():
				fall(fall_gravity,delta);
				updateState(states.FALLING)
		states.JUMPING:
			if direction:
				if !checkForPauseAhead():
					velocity.x = clampf(velocity.x + direction * AIRACCEL * delta,-TOPSPEED,TOPSPEED)
			else:
				if !checkForPauseAhead():
					velocity.x = move_toward(velocity.x, 0, AIRACCEL * delta);
			if not is_on_floor(): #why wouldn't they be????
				if useJumpGravity:
					fall(jump_gravity,delta);
				else:
					fall(fall_gravity,delta);
				if velocity.y > 0:
					updateState(states.FALLING)
			else:
				if direction:
					updateState(states.WALKING)
				else:
					updateState(states.IDLE);
			if Input.is_action_just_released("Jump") && acceptingInput:
				useJumpGravity = false;
		states.FALLING:
			if direction:
				if !checkForPauseAhead():
					#soooo many indents UGH this code is GARBAGE
					velocity.x = clampf(velocity.x + direction * AIRACCEL * delta,-TOPSPEED,TOPSPEED)
			else:
				if !checkForPauseAhead():
					velocity.x = move_toward(velocity.x, 0, AIRACCEL * delta);
			if not is_on_floor():
				fall(fall_gravity,delta);
			else:
				if direction:
					updateState(states.WALKING)
				else:
					updateState(states.IDLE);

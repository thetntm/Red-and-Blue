extends CharacterBody2D

enum states {IDLE,WALKING,JUMPING,FALLING};

@onready var animator : AnimationPlayer = $CharacterAnimator;
@onready var blueSprite : Sprite2D = $blueshade/blueSprite;
@onready var redSprite : Sprite2D = $redshade/redSprite;
@onready var finalPassShader : FinalPass = $Camera2D/Finalpass;

var state = states.IDLE;

#This math is from the video "making a jump you can actually use in godot" courtesy of Pefeper. Check out their video on it, the rest of the code for actually using these variables is mine.
#@export var jump_height : float
#@export var jump_time_to_peak : float
#@export var jump_time_to_descent : float

#@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
#@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
#@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var TOPSPEED = 300.0 * 0.45;
@export var ACCEL = TOPSPEED * 7; #it's high because it's gonna be scaled for delta time, TRUST ME.
@export var AIRACCEL = ACCEL / 2.0;
@export var JUMP_VELOCITY = -400.0 * 0.58;
@export var jump_gravity = 980 / 2.5;
@export var fall_gravity = 980 / 1.2;

var useJumpGravity : bool = false;
#why the fuck do collisions start at 1 what the fuck is wrong with you godot
enum modes {NIL,GODOTISSTUPIDSOMETIMES,RED,BLUE,ALL}

var currentMode = modes.RED;

func _ready():
	set_collision();
	print(modes.RED)
	print(modes.BLUE)
	#set_collision_mask_value(currentMode,true);
	pass;

func set_collision():
	set_collision_mask_value(modes.ALL,false);
	set_collision_mask_value(modes.RED,false);
	set_collision_mask_value(modes.BLUE,false);
	set_collision_mask_value(currentMode,true);
	finalPassShader.mode = currentMode;

func _physics_process(delta):
	#Get the direction:
	var direction = Input.get_axis("Left", "Right")
	stateMachine(direction,delta);
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("Shift"):
		if currentMode == modes.RED:
			currentMode = modes.BLUE;
			set_collision();
		elif currentMode == modes.BLUE:
			currentMode = modes.RED;
			set_collision();
		else:
			currentMode = modes.ALL;
			set_collision();


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
			animator.play("Fall")
			
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
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				updateState(states.JUMPING);
			if not is_on_floor(): #why wouldn't you be??????
				velocity.y += fall_gravity * delta
				updateState(states.FALLING)
		states.WALKING:
			if direction:
				velocity.x = clampf(velocity.x + direction * ACCEL * delta,-TOPSPEED,TOPSPEED)
				redSprite.flip_h = sign(velocity.x) - 1;
				blueSprite.flip_h = sign(velocity.x) - 1;
			else:
				updateState(states.IDLE);
				velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				updateState(states.JUMPING);
			if not is_on_floor():
				velocity.y += fall_gravity * delta
				updateState(states.FALLING)
		states.JUMPING:
			if direction:
				velocity.x = clampf(velocity.x + direction * AIRACCEL * delta,-TOPSPEED,TOPSPEED)
			else:
				velocity.x = move_toward(velocity.x, 0, AIRACCEL * delta);
			if not is_on_floor(): #why wouldn't they be????
				if useJumpGravity:
					velocity.y += jump_gravity * delta
				else:
					velocity.y += fall_gravity * delta
				if velocity.y > 0:
					updateState(states.FALLING)
			else:
				if direction:
					updateState(states.WALKING)
				else:
					updateState(states.IDLE);
			if Input.is_action_just_released("Jump"):
				useJumpGravity = false;
		states.FALLING:
			if direction:
				velocity.x = clampf(velocity.x + direction * AIRACCEL * delta,-TOPSPEED,TOPSPEED)
			else:
				velocity.x = move_toward(velocity.x, 0, AIRACCEL * delta);
			if not is_on_floor():
				velocity.y += fall_gravity * delta
			else:
				if direction:
					updateState(states.WALKING)
				else:
					updateState(states.IDLE);

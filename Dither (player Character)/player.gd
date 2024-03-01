extends CharacterBody2D

enum states {IDLE,WALKING,JUMPING,FALLING};

@onready var animator : AnimationPlayer = $CharacterAnimator;
@onready var blueSprite : Sprite2D = $blueshade/blueSprite;
@onready var redSprite : Sprite2D = $redshade/redSprite;

var state = states.IDLE;

#This math is from the video "making a jump you can actually use in godot" courtesy of Pefeper. Check out their video on it, the rest of the code for actually using these variables is mine.
#@export var jump_height : float
#@export var jump_time_to_peak : float
#@export var jump_time_to_descent : float

#@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
#@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
#@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var SPEED = 300.0 * 0.5
@export var JUMP_VELOCITY = -400.0 * 0.75

func _physics_process(delta):
	var gravity = 980 / 2;
	#Get the direction:
	var direction = Input.get_axis("ui_left", "ui_right")
	#fuck fuck fuck why did I make this SO MUCH MORE COMPLICATED THAN IT NEEDED TO BE
	match state:
		states.IDLE:
			if direction:
				velocity.x = direction * SPEED
				redSprite.flip_h = sign(direction) - 1;
				updateState(states.WALKING);
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				updateState(states.JUMPING);
			if not is_on_floor(): #why wouldn't you be??????
				velocity.y += gravity * delta
				updateState(states.FALLING)
		states.WALKING:
			if direction:
				velocity.x = direction * SPEED
				redSprite.flip_h = sign(direction) - 1;;
			else:
				updateState(states.IDLE);
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				updateState(states.JUMPING);
			if not is_on_floor():
				velocity.y += gravity * delta
				updateState(states.FALLING)
		states.JUMPING:
			if direction:
				velocity.x = direction * SPEED;
			if not is_on_floor():
				velocity.y += gravity * delta
				if velocity.y > 0:
					updateState(states.FALLING)
			else:
				if direction:
					updateState(states.WALKING)
				else:
					updateState(states.IDLE);
		states.FALLING:
			if direction:
				velocity.x = direction * SPEED;
			if not is_on_floor():
				velocity.y += gravity * delta
			else:
				if direction:
					updateState(states.WALKING)
				else:
					updateState(states.IDLE);
	move_and_slide()

func updateState(newState):
	state = newState;
	updateAnimation();
	print(state);

func updateAnimation():
	match state:
		states.IDLE:
			animator.play("Idle")
		states.WALKING:
			animator.play("Run");
		states.JUMPING:
			animator.play("Jump")
		states.FALLING:
			animator.play("Fall")

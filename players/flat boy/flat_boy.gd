extends CharacterBody2D


enum CharacterState {
	IDLE,
	JUMP,
	DEAD,
	RUN,
	WALK
}

var current_state = CharacterState.IDLE

var move_speed := 200  # Vitesse de déplacement
var acceleration := 1000  # Accélération
var gravity := 1000  # Gravité
var jump_force := -500  # Force de saut


var is_moving_right := false
var is_moving_left := false
var is_jumping := false
var is_attacking := false


@onready var animation_player = $AnimatedSprite2D


func _physics_process(delta):
	# Appliquer la gravité
	velocity.y += gravity * delta
	
	
	match current_state:
		CharacterState.IDLE:
			handle_idle_state()
		CharacterState.JUMP:
			handle_jump_state()
		CharacterState.DEAD:
			handle_dead_state()
		CharacterState.RUN:
			handle_run_state()
		CharacterState.WALK:
			handle_walk_state()
			
	# Déplacer le personnage
	move_and_slide()

func handle_idle_state():
	if is_moving_right:
		current_state = CharacterState.WALK
	elif is_moving_left:
		current_state = CharacterState.WALK
	elif is_jumping:
		current_state = CharacterState.JUMP
	elif is_attacking:
		current_state = CharacterState.RUN
	animation_player.play("idle")
	velocity.x = lerp(velocity.x, 0.0, acceleration * get_physics_process_delta_time())  # Réduire la vitesse en cas d'arrêt


func handle_jump_state():
	# Logique de l'état JUMP
	if is_on_floor():
		current_state = CharacterState.IDLE
		velocity.y = jump_force
	animation_player.play("jump")

func handle_dead_state():
	# Logique de l'état DEAD
	# Vous pouvez gérer la logique de la mort ici
	animation_player.play("dead")

func handle_run_state():
	if not is_moving_right and not is_moving_left:
		current_state = CharacterState.IDLE
	elif is_jumping:
		current_state = CharacterState.JUMP
	elif is_attacking:
		current_state = CharacterState.RUN
	animation_player.play("run")
	velocity.x = lerp(velocity.x, move_speed, acceleration * get_physics_process_delta_time())  # Accélérer en courant


func handle_walk_state():
	if not is_moving_right and not is_moving_left:
		current_state = CharacterState.IDLE
	elif is_jumping:
		current_state = CharacterState.JUMP
	elif is_attacking:
		current_state = CharacterState.RUN
	animation_player.play("walk")
	velocity.x = lerp(velocity.x, move_speed / 2, acceleration * get_physics_process_delta_time())  # Accélérer en marchant


func update_actions_context():
	is_moving_right = Input.is_action_pressed("ui_right")
	is_moving_left = Input.is_action_pressed("ui_left")
	is_jumping = Input.is_action_pressed("ui_accept")
	is_attacking = Input.is_action_pressed("ui_down")

func _ready():
	current_state = CharacterState.IDLE



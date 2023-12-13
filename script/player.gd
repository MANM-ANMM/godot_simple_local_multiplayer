extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -800.0

enum Commandes {
	MoveLeft,
	MoveRight,
	Jump,
}

@export var player_id:=0:
	set(value):
		if value==player_id: return
		player_id = value
		generer_input_map(player_id)

func generer_input_map(player_id: int):
	input_map = [
		"move_left_"+str(player_id),
		"move_right_"+ str(player_id),
		"jump_"+str(player_id),
	]

var input_map : Array[String]

func _ready():
	generer_input_map(player_id)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(input_map[Commandes.Jump]) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(input_map[Commandes.MoveLeft], input_map[Commandes.MoveRight])
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

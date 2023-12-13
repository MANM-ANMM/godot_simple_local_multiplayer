extends Node2D

signal new_player_connected(player:Player)

const connect_actions := {
	"jump_0": 0,
	"jump_1": 1,
	"jump_2": 2,
}

var connected : Array[int]

@export var player_scene:PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for a in connect_actions:
		if Input.is_action_just_pressed(a):
			var num : int = connect_actions[a]
			if not connected.has(num):
				spawn_player(num)

func spawn_player(id:int):
	connected.push_back(id)
	var new_player : Player = player_scene.instantiate()
	new_player.player_id = id
	new_player.position = get_child(id).position
	add_sibling(new_player)
	emit_signal("new_player_connected", new_player)

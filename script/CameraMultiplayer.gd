extends Camera2D


var players : Array[Player]

## Camera move speed (speed depends of distance to travel)
@export var speed:=1.0
## Camera max zoom, use it to prevent the camera from coming to close
@export var max_zoom := 1.0
## The target ratio for (the space between players and the camera center / an half screen width distance)
@export var ratio_ecart_largeur_cible:=0.4
## Camera zoom speed (speed depends of distance to travel)
@export var zoom_speed:=15.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta:float):
	basic_follow(delta)
	linear_scale(delta)

func _on_players_connector_new_player_connected(player):
	players.push_back(player)

func basic_follow(delta:float):
	if players.is_empty(): return
	var moyenne_positions:= compute_moyenne_positions()
	var ecart:= moyenne_positions-position
	position += ecart*delta*speed

func linear_scale(delta:float):
	if players.is_empty(): return
	var ecart_moyen:= compute_ecart_moyen()
	var taille := get_viewport_rect().size.x / zoom.x
	
	var ratio_ecart_taille := 2*ecart_moyen/taille
	
	var ecart := ratio_ecart_largeur_cible-ratio_ecart_taille
	
	var variation = delta*ecart * zoom_speed
	zoom += Vector2(variation, variation)
	zoom.x = min(max_zoom, zoom.x)
	zoom.y = min(max_zoom, zoom.y)

func compute_moyenne_positions()->Vector2 :
	return players.map(func(p): return p.position) \
		.reduce(func(accum, pos): return accum + pos, Vector2.ZERO) / players.size()

func compute_ecart_moyen()->float:
	return players.map(func(p): return p.position.x) \
		.reduce(func(accum, pos): return accum + abs(pos-position.x), 0) / players.size()


class_name TeslaProjectile
extends AbstractProjectile


@export_range(0.01, 0.5) var jink_min_delay: float = 0.01
@export_range(0.01, 0.5) var jink_max_delay: float = 0.01
@export_range(0, 360) var deviation_angle: int = 0
@export_range(0, 1000) var no_deviation_distance: int = 0


@onready var jinkTimer : Timer = $JinkTimer


var _collided_foes : Array[AbstractShip] = []


func _ready() -> void:
	damage = damage.duplicate()
	super._ready()
	_start_jink_timer()


func _process_hit_for_projectile(collided_body: Node2D) -> void:
	if collided_body is AbstractShip:
		_collided_foes.append(collided_body)

	damage.value = floor(damage.value/2.0)
	
	if damage.value == 0:
		queue_free()
	else:
		_apply_random_deviation()
		_start_jink_timer()


func _start_jink_timer() -> void:
	var random_delay := randf_range(jink_min_delay, jink_max_delay)
	jinkTimer.start(random_delay)


func _on_jink_timer_timeout() -> void:
	var foe := _get_nearest_foe()
	if foe:
		_target_foe(foe)
		if position.distance_to(foe.position) > no_deviation_distance:
			_apply_random_deviation()
	else:
		_apply_random_deviation()
	
	_start_jink_timer()


func _target_foe(foe: AbstractShip) -> void:
	var current_speed := _velocity.length()
	var foe_direction := position.direction_to(foe.position)
	_velocity = current_speed * foe_direction


func _apply_random_deviation() -> void:
	var deviation_rad := deg_to_rad(deviation_angle)
	var random_angle := randfn(0.0, deviation_rad / 6.0)
	_velocity = _velocity.rotated(random_angle)


func _get_nearest_foe() -> AbstractShip:
	var nearest_foe : AbstractShip = null
	var minimal_distance := 1000000
	
	for foe in _get_foes():
		var distance := floori(position.distance_to(foe.position))
		if distance < minimal_distance:
			minimal_distance = distance
			nearest_foe = foe
	
	return nearest_foe


func _get_foes() -> Array[AbstractShip]:
	var foes : Array[AbstractShip] = []
	
	var flags_by_group : Dictionary[String, bool] = {
		"enemies": collide_enemies,
		"players": collide_players,
	}
	
	for group in flags_by_group:
		if not flags_by_group[group]: continue
		var nodes := get_tree().get_nodes_in_group(group)
		for node in nodes:
			if not node in _collided_foes:
				foes.append(node)
	
	return foes

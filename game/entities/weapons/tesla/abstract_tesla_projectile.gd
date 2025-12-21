class_name AbstractTeslaProjectile
extends AbstractDirectHitProjectile


@export_range(0.01, 0.5) var jink_min_delay: float = 0.01
@export_range(0.01, 0.5) var jink_max_delay: float = 0.01
@export_range(0, 360) var deviation_angle: int = 0
@export_range(0, 1000) var no_deviation_distance: int = 0


var _collided_foes : Array[AbstractShip] = []
var _current_line: Line2D


@onready var jink_timer : Timer = $JinkTimer
@onready var life_timer : Timer = $LifeTimer

@onready var line_thin : Line2D = $LineThin
@onready var line_thick : Line2D = $LineThick


func _ready() -> void:
	super._ready()
	_start_jink_timer()
	
	line_thin.hide()
	_current_line = line_thick
	_current_line.add_point(position)
	
	_prepare_line(line_thin)
	_prepare_line(line_thick)


func _prepare_line(line: Line2D) -> void:
	line.reparent(get_tree().current_scene)
	line.global_position = Vector2.ZERO


func _process(_delta: float) -> void:
	_update_line_points()


func _process_hit_for_projectile(collided_body: Node2D) -> void:
	if collided_body is AbstractShip:
		_collided_foes.append(collided_body)
	
	damage.value = floor(damage.value/2.0)
	if damage.value == 0:
		_start_fading()
	
	_velocity = _apply_random_deviation(_velocity)
	_start_jink_timer()


func delete() -> void:
	line_thin.queue_free()
	line_thick.queue_free()
	super.delete()


func _on_out_of_screen_timer_timeout() -> void:
	_start_fading()


func _update_line_points() -> void:
	_current_line.add_point(position)
	
	if weapon != null:
		var points := _move_points_follow_weapon(_current_line.points)
		_current_line.clear_points()
		for point : Vector2 in points:
			_current_line.add_point(point)


func _move_points_follow_weapon(points: PackedVector2Array) -> Array[Vector2]:
	var new_points : Array[Vector2] = []
	
	var new_point := weapon.global_position
	for i in range(points.size() - 1):
		new_points.append(new_point)
		
		var distance_old := points[i].distance_to(points[i+1])
		var distance_new := new_points[i].distance_to(points[i+1])
		var distance := distance_old - (distance_old - distance_new)/2
		
		new_point = new_points[i] + points[i].direction_to(points[i+1]) * distance
	new_points.append(points[points.size()-1])
	
	return new_points


func _start_jink_timer() -> void:
	var random_delay := randf_range(jink_min_delay, jink_max_delay)
	jink_timer.start(random_delay)


func _on_jink_timer_timeout() -> void:
	var foe := _get_nearest_foe(_collided_foes)
	if foe:
		_target_foe(foe)
		if position.distance_to(foe.position) > no_deviation_distance:
			_velocity = _apply_random_deviation(_velocity)
	else:
		_velocity = _apply_random_deviation(_velocity)
	
	_start_jink_timer()


func _target_foe(foe: AbstractShip) -> void:
	var current_speed := _velocity.length()
	var foe_direction := position.direction_to(foe.position)
	_velocity = current_speed * foe_direction


func _apply_random_deviation(vector: Vector2) -> Vector2:
	var deviation_rad := deg_to_rad(deviation_angle)
	var random_angle := randfn(0.0, deviation_rad)
	return vector.rotated(random_angle)


func _start_fading() -> void:
	line_thick.hide()
	line_thin.show()
	
	for point in line_thick.points:
		line_thin.add_point(point)
	
	_current_line = line_thin
	
	life_timer.start()


func _on_life_timer_timeout() -> void:
	delete()

class_name AbstractTeslaProjectile
extends AbstractDirectHitProjectile


@export_range(0.01, 0.5) var jink_min_delay: float = 0.01
@export_range(0.01, 0.5) var jink_max_delay: float = 0.01
@export_range(0, 360) var deviation_angle: int = 0
@export_range(0, 1000) var no_deviation_distance: int = 0


var _collided_foes : Array[AbstractShip] = []


@onready var jink_timer : Timer = $JinkTimer
@onready var life_timer : Timer = $LifeTimer

@onready var line_thin : Line2D = $LineThin
@onready var line_thick : Line2D = $LineThick


func _ready() -> void:
	super._ready()
	_start_jink_timer()
	
	_prepare_line(line_thin)
	_prepare_line(line_thick)
	line_thin.hide()


func _prepare_line(line: Line2D) -> void:
	line.reparent(get_tree().current_scene)
	line.global_position = Vector2.ZERO
	line.add_point(position)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	line_thin.add_point(position)
	line_thick.add_point(position)


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
	life_timer.start()


func _on_life_timer_timeout() -> void:
	delete()


func _on_out_of_screen_timer_timeout() -> void:
	_start_fading()

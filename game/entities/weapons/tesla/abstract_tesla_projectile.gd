class_name AbstractTeslaProjectile
extends AbstractDirectHitProjectile


const SPIKE_WIDTH = 1
const SPIKE_MIN_LENGTH = 10.0
const SPIKE_MAX_LENGTH = 50.0


@export_range(0.01, 0.5) var jink_min_delay: float = 0.01
@export_range(0.01, 0.5) var jink_max_delay: float = 0.01
@export_range(0, 360) var deviation_angle: int = 0
@export_range(0, 1000) var no_deviation_distance: int = 0


var _collided_foes : Array[AbstractShip] = []

var _is_dead := false
var _is_expanding := true
var _removed_point_count := 0

var _spikes_by_point_count : Dictionary[int, Array] = {}


@onready var jinkTimer : Timer = $JinkTimer
@onready var lifeTimer : Timer = $LifeTimer

@onready var line : Line2D = $Line2D


func _ready() -> void:
	super._ready()
	_start_jink_timer()
	line.reparent(get_tree().current_scene)
	line.global_position = Vector2.ZERO
	line.add_point(position)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if _is_dead:
		line.remove_point(0)
		_removed_point_count += 1
		
		if _removed_point_count in _spikes_by_point_count:
			var lines := _spikes_by_point_count[_removed_point_count]
			for l : Line2D in lines:
				l.queue_free()
		
		if line.get_point_count() == 0:
			delete()
	
	if _is_expanding:
		line.add_point(position)


func _process_hit_for_projectile(collided_body: Node2D) -> void:
	if collided_body is AbstractShip:
		_collided_foes.append(collided_body)
	
	damage.value = floor(damage.value/2.0)
	
	_velocity = _apply_random_deviation(_velocity)
	_start_jink_timer()


func delete() -> void:
	line.queue_free()
	super.delete()


func _start_jink_timer() -> void:
	var random_delay := randf_range(jink_min_delay, jink_max_delay)
	jinkTimer.start(random_delay)


func _on_jink_timer_timeout() -> void:
	var foe := _get_nearest_foe(_collided_foes)
	if foe:
		_target_foe(foe)
		if position.distance_to(foe.position) > no_deviation_distance:
			_velocity = _apply_random_deviation(_velocity)
	else:
		_velocity = _apply_random_deviation(_velocity)
	
	_create_spike()
	
	_start_jink_timer()


func _create_spike() -> void:
	if _is_dead: return
	
	var point_count := line.get_point_count()
	if not point_count in _spikes_by_point_count:
		_spikes_by_point_count[point_count] = []
	
	var spike_direction := _apply_random_deviation(_velocity).normalized()
	var spike_length := randf_range(SPIKE_MIN_LENGTH, SPIKE_MAX_LENGTH)
	var second_point := position + spike_direction * spike_length
	
	var spike : Line2D = line.duplicate()
	get_parent().add_child(spike)
	spike.clear_points()
	spike.add_point(position)
	spike.add_point(second_point)
	spike.width = SPIKE_WIDTH
	spike.width_curve = null
	
	_spikes_by_point_count[point_count].append(spike)


func _target_foe(foe: AbstractShip) -> void:
	var current_speed := _velocity.length()
	var foe_direction := position.direction_to(foe.position)
	_velocity = current_speed * foe_direction


func _apply_random_deviation(vector: Vector2) -> Vector2:
	var deviation_rad := deg_to_rad(deviation_angle)
	var random_angle := randfn(0.0, deviation_rad / 6.0)
	return vector.rotated(random_angle)


func _on_life_timer_timeout() -> void:
	_is_dead = true


func _on_out_of_screen_timer_timeout() -> void:
	_is_expanding = false

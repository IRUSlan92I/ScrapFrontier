class_name ExplosionParticles
extends Node2D


signal finished


@export var process_material: ParticleProcessMaterial
@export_range(0, 1) var amount_ratio: float = 1


@onready var particles_huge : GPUParticles2D = $ParticlesHuge
@onready var particles_large : GPUParticles2D = $ParticlesLarge
@onready var particles_medium : GPUParticles2D = $ParticlesMedium


var _emiting_count := 0


var emitting : bool = false:
	set(value):
		emitting = value
		if particles_huge: particles_huge.emitting  = emitting; _emiting_count += 1
		if particles_large: particles_large.emitting = emitting; _emiting_count += 1
		if particles_medium: particles_medium.emitting = emitting; _emiting_count += 1


func _ready() -> void:
	particles_huge.amount_ratio = amount_ratio
	particles_large.amount_ratio = amount_ratio
	particles_medium.amount_ratio = amount_ratio
	particles_huge.process_material = process_material
	particles_large.process_material = process_material
	particles_medium.process_material = process_material


func _on_particles_finished() -> void:
	_emiting_count -= 1
	if _emiting_count == 0:
		finished.emit()

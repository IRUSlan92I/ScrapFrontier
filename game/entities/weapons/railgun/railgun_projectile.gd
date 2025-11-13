class_name RailgunProjectile
extends AbstractProjectile


@export_range(1, 10) var piercing: int = 1


@onready var sprite_left := $Sprite2D_Left
@onready var sprite_right := $Sprite2D_Right


func _ready() -> void:
	super._ready()
	_update_sprite(_velocity)


func _update_sprite(velocity: Vector2) -> void:
	var angle := posmod(floor(rad_to_deg(velocity.angle())), 360)
	
	if angle > 90 and angle < 270:
		sprite_left.show()
		sprite_right.hide()
	else:
		sprite_left.hide()
		sprite_right.show()


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	if piercing == 0:
		queue_free()
	else:
		piercing -= 1

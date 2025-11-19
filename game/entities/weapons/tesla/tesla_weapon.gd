extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)

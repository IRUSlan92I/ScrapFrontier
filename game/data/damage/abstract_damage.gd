@abstract
class_name AbstractDamage
extends Resource


@export_range(1, 250) var value: int = 1


@abstract
func shield_damage_multiplier() -> float


@abstract
func armor_damage_multiplier() -> float


@abstract
func hull_damage_multiplier() -> float

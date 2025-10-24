@abstract
class_name AbstractReloader
extends Node


var _random := RandomNumberGenerator.new()


@abstract
func can_shoot() -> bool


@abstract
func shoot() -> void


@abstract
func reload() -> void


@abstract
func get_process_percent() -> int

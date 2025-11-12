@abstract
extends Resource
class_name AbstractReloader


@abstract
func process(delta: float) -> void


@abstract
func can_shoot() -> bool


@abstract
func shoot() -> void


@abstract
func reload() -> void


@abstract
func get_process_percent() -> int

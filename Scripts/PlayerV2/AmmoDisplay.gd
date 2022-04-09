extends ProgressBar

onready var player = owner

var last_value := 0

func _ready() -> void:
	max_value = player.laser_max_ammo
func _process(delta: float) -> void:
	if player.laser_ammo == value: 
		return
	
	var tween = $Tween
	tween.interpolate_property(self, "value",
		value, player.laser_ammo, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	last_value = player.laser_ammo

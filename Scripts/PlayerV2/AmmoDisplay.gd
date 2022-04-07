extends ProgressBar

onready var player = owner

var last_value := 0

func _ready() -> void:
	max_value = player.laser_max_ammo
	print(max_value)
func _process(delta: float) -> void:
	if player.laser_ammo == last_value: 
		return
	last_value = player.laser_ammo
	
	var tween = $Tween
	tween.interpolate_property(self, "value",
		value, player.laser_ammo, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	
#	value = player.laser_ammo
	

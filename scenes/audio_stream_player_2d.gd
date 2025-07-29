extends AudioStreamPlayer2D

var max_volume_db = 10

func _ready():
		volume_db = -80
		play()

func _process(delta):
	var incremento = 60 * delta
	if volume_db < max_volume_db:
		volume_db += incremento
		if volume_db > max_volume_db:
			volume_db = max_volume_db

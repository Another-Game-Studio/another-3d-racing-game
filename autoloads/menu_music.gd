extends AudioStreamPlayer

func _ready() -> void:
	if stream:
		stream.loop = true
	play()

extends TextureButton

var tween



func _on_pressed():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -400, 0.5)
	tween.tween_callback(queue_free)
	tween.play()
	

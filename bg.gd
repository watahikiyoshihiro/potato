extends Sprite2D

var tween

func _ready():
	tween = get_tree().create_tween()
	tween.set_loops()
	#tween.tween_property(self, "position:x", 300, 0)
	tween.tween_property(self, "position:x", 216, 3)
	tween.tween_property(self, "position:x", 300, 3)
	tween.play()
	
	
func _notification(what):
	# predelete
	if what == NOTIFICATION_PREDELETE:
		print('reset')
		tween.kill()
	
	#finish close
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print('byebye')
		tween.kill()
	

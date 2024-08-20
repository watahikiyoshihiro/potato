extends Node

@export var stick_count :int = 20
@onready var label = $HSlider/Label
const STICK = preload("res://stick.tscn") #stickシーンをプリロード　先読み込み
var tween 

# click lid 
func _on_lid_pressed():
	$HSlider.queue_free()
	$lid.queue_free()
	$TelopStart.queue_free()
	
	tween = get_tree().create_tween()
	tween.set_parallel(true) #Run simultaneously　同時に実行
	tween.tween_property($JyagaBack, "position", Vector2(240, 225), 0.5)
	tween.tween_property($JyagaFront, "position", Vector2(240, 225), 0.5)
	
	await tween.finished
	tween.kill()
	stick_init()
	

func stick_init():
	print('hello stick')
	for i in stick_count:
		var stick = STICK.instantiate() # プリロードしたSTICKをインスタンス化
		stick.position.x = -80 + i * (160 / stick_count)
		stick.position.y = -150
		stick.rotation_degrees = -15.0 + i * (30 / stick_count)
		
		$JyagaBack.add_child(stick)

# slider's value
func _on_h_slider_value_changed(value):
	stick_count = value
	label.text = str(stick_count, "本")

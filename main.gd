extends Node

@export var stick_count :int = 20
@onready var label = $HSlider/Label
@onready var marisa = $Marisa
@onready var reimu = $Reimu


const STICK = preload("res://stick.tscn") #stickシーンをプリロード　先読み込み
var tween 

var marisa_scale = Vector2(0.15, 0.15)
var reimu_scale = Vector2(0.12, 0.12)

func _process(delta):
	if marisa.scale.distance_to(marisa_scale) > 0.01:
		marisa.scale = lerp(marisa.scale, marisa_scale, 5.0 * delta) #The closer the distance, the slower the movement
	
	if reimu.scale.distance_to(reimu_scale) > 0.01:
		reimu.scale = lerp(reimu.scale, reimu_scale, 5.0 * delta) #The closer the distance, the slower the movement

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
		stick.position.x = -80 + i * (160 / float(stick_count))
		stick.position.y = -150
		stick.rotation_degrees = -15.0 + i * (30 / float(stick_count))
		
		#add a random position 
		stick.position += Vector2(randf_range(-10.0,10.0), randf_range(-10.0,10.0))
		
		$JyagaBack.add_child(stick)
		
		stick.pressed.connect(pick_stick)
		change_turn()
		
func pick_stick():
	print('picked stick')
	$pui.play()
	
	if randf_range(1, stick_count) == 1:
		boom()
	else:
		stick_count -= 1
		change_turn()
		
func boom():
	print('booooom!!!')
	$boom.play()
	
	if stick_count % 2 == 0:
		marisa.animation = "lose"
		reimu.animation = "win"
		
	else:
		reimu.animation = "lose"
		marisa.animation = "win"
	
	for i in 20:
		$Camera2D.offset.x = 240 + randf_range(-10,10)
		$Camera2D.offset.y = 180 + randf_range(-10,10)
		await get_tree().create_timer(0.01).timeout
	
	$Camera2D.offset = Vector2(240, 180)
	
func change_turn():
	print('change turn')
	
	if stick_count % 2 == 0:
		marisa_scale = Vector2(0.15, 0.15)
		reimu_scale = Vector2(0.12, 0.12)
	
	else:
		reimu_scale = Vector2(0.15, 0.15)
		marisa_scale = Vector2(0.12, 0.12)
		
		
# slider's value
func _on_h_slider_value_changed(value):
	stick_count = value
	label.text = str(stick_count, "本")

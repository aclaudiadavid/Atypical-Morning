extends Position2D


onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0
var desc = ""
var type = ""
var vel = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#label.set_text(str(amount))
	
	match type:
		"Heal":
			label.set_text(str(amount))
			label.set("custom_colors/font_color", Color("2eff27"))
			randomize()
			var side_mov = randi() % 121 - 20
			vel = Vector2(side_mov, 50)
			tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
			tween.start()
		"Damage":
			label.set_text(str(amount))
			label.set("custom_colors/font_color", Color("ff3131"))
			randomize()
			var side_mov = randi() % 121 - 20
			vel = Vector2(side_mov, 50)
			tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
			tween.start()
		"Sickness":
			label.set_text(str(amount))
			label.set("custom_colors/font_color", Color("656616"))
			randomize()
			var side_mov = randi() % 121 - 20
			vel = Vector2(side_mov, 50)
			tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
			tween.start()
		"Shield":
			label.set_text(str(amount))
			label.set("custom_colors/font_color", Color("0d7dca"))
			randomize()
			var side_mov = randi() % 121 - 20
			vel = Vector2(side_mov, 50)
			tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
			tween.start()
		"Item":
			label.set_text(desc)
			print(desc)
			label.set("custom_colors/font_color", Color("f3ec09"))
			#randomize()
			#var side_mov = randi() % 121 - 20
			vel = Vector2(0, 50)
			tween.interpolate_property(self, 'scale', scale, Vector2(0.4, 0.4), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.interpolate_property(self, 'scale', Vector2(0.5, 0.5), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1.3)
			tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()
	
func _process(delta):
	position -= vel * delta

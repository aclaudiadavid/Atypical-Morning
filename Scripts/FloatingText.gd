extends Position2D


onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0
var type = ""
var vel = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(str(amount))
	
	match type:
		"Heal":
			label.set("custom_colors/font_color", Color("2eff27"))
		"Damage":
			label.set("custom_colors/font_color", Color("ff3131"))
		"Sickness":
			label.set("custom_colors/font_color", Color("656616"))
		"Shield":
			label.set("custom_colors/font_color", Color("0d7dca"))
		"Item":
			label.set("custom_colors/font_color", Color("f3ec09"))
	randomize()
	var side_mov = randi() % 121 - 20
	vel = Vector2(side_mov, 50)
	tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()
	
func _process(delta):
	position -= vel * delta

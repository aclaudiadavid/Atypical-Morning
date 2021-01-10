extends Area2D
signal collect

func _ready():
	self.connect("collect", get_node("../Character"), "_on_Pill_collect")

func _on_Pill_body_entered(body):
	emit_signal("collect")
	queue_free()

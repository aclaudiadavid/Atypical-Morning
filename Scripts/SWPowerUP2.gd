extends Node2D

var floating_text = preload("res://Scenes/FloatingText.tscn")

func _ready():
	$AnimatedSprite.play("idle")

func _on_Area2D_body_entered(body):
	if "Character" in body.name:
		body.boostSwordDamage()
		var text = floating_text.instance()
		text.desc = "+SWORD DMG"
		text.type = "Item"
		add_child(text)
		queue_free()


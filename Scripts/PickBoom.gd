extends Node2D

func _ready():
	$AnimatedSprite.play("idle")

func _on_Area2D_body_entered(body):
	if "Character" in body.name:
		body.pick_boom()
		queue_free()

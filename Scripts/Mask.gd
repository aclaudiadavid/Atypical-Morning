extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")


func _on_Area2D_body_entered(body):
	if "Character" in body.name:
		body.collect_mask()
		queue_free()

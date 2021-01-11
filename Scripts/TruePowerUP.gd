extends Node2D



func _ready():
	$AnimatedSprite.play("idle")

func _on_Area2D_body_entered(body):
	if "Character" in body.name:
		if PlayerVars.boomerangON:
			body.double_boom()
		if PlayerVars.sanitizerON:
			body.boostSanDamage()
		if PlayerVars.swordON:
			body.boostSwordDamage()
		queue_free()

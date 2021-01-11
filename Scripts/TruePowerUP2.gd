extends Node2D



func _ready():
	$AnimatedSprite.play("idle")

func _on_Area2D_body_entered(body):
	if "Character" in body.name:
		if PlayerVars.boomerangON:
			body.boostBoomDist()
		if PlayerVars.sanitizerON:
			body.cutCD()
		if PlayerVars.swordON:
			body.boostSwordDamage()
		queue_free()

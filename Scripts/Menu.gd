extends Node2D


func _ready():
	$Sprite/Mountain.visible = true
	$Sprite/Beach.visible = true
	$Sprite/Market.visible = true
	$Sprite/Hospital.visible = true
	$Sprite/Park.visible = true
	$Sprite/SuperMarket.visible = true
	
	if Global.lastScene == "First":
		$Sprite/Hospital.visible = false
		$Sprite/Park.visible = false
		$Sprite/SuperMarket.visible = false
	if Global.lastScene == "Mountain":
		$Sprite/Mountain.visible = false
		$Sprite/Beach.visible = false
		$Sprite/Market.visible = false
		$Sprite/Park.visible = false
		$Sprite/SuperMarket.visible = false
	if Global.lastScene == "Market":
		$Sprite/Mountain.visible = false
		$Sprite/Beach.visible = false
		$Sprite/Market.visible = false
		$Sprite/SuperMarket.visible = false
	if Global.lastScene == "Beach":
		$Sprite/Mountain.visible = false
		$Sprite/Beach.visible = false
		$Sprite/Market.visible = false
		$Sprite/Hospital.visible = false
		$Sprite/SuperMarket.visible = false
	if Global.lastScene == "Hospital" or Global.lastScene == "Park":
		$Sprite/Mountain.visible = false
		$Sprite/Beach.visible = false
		$Sprite/Market.visible = false
		$Sprite/Hospital.visible = false
		$Sprite/Park.visible = false

extends Node2D

## This is the code of SnowyArena, i will optimize it to make spawn animation on start, and click any Key to start.
## Smooth Camera Moves and Dramitic Camera, ETC.......................

## DON'T TOUCH IT PLEASE. 

func _process(delta: float) -> void:
	$BossFight/HealthBar/TextureProgressBar.value = $Frostbite.health

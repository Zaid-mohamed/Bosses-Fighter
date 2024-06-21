extends Node2D

var game_started = false

func _ready():
	randomize()
	$player.set_physics_process(false)

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		if !game_started:
			$CanvasLayer.queue_free()
			$AnimationPlayer.play("anim")
			$player/UI.visible = true
			game_started = true

func _physics_process(delta):
	if has_node("SnowyBoss") && get_node("SnowyBoss").current_state != get_node("SnowyBoss").States.DEAD:
		if !get_node("SnowyBoss").is_connected("dead",SnowyBoss_died):
			get_node("SnowyBoss").connect("dead",SnowyBoss_died)

func SnowyBoss_died(pos : Vector2):
	pass

func next_level(body : Node2D):
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "anim":
		$player.set_physics_process(true)
		await get_tree().create_timer(1).timeout
		var Boss_instance = preload("res://scenes/SnowyBoss/SnowyBoss.tscn").instantiate()
		Boss_instance.target = $player
		Boss_instance.position = $Center.position
		add_child(Boss_instance)

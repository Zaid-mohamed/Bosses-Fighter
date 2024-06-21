extends Node2D

var game_started = false

func _ready():
	randomize()
	$player.set_physics_process(false)

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		if !game_started:
			$CanvasLayer.queue_free()
			$player/UI.visible = true
			game_started = true

func _physics_process(delta):
	if has_node("SnowyBoss") && get_node("SnowyBoss").current_state != get_node("SnowyBoss").States.DEAD:
		if $Timer.is_stopped():
			$Timer.start()
		$CanvasLayer/Control2/ProgressBar.value = $SnowyBoss.health
		$CanvasLayer/Control2.modulate = lerp($CanvasLayer/Control2.modulate,Color(1, 1, 1, 1),0.2)
		if !get_node("SnowyBoss").is_connected("dead",SnowyBoss_died):
			get_node("SnowyBoss").connect("dead",SnowyBoss_died)
	else:
		if !$Timer.is_stopped():
			$Timer.stop()
		$CanvasLayer/Control2.modulate = lerp($CanvasLayer/Control2.modulate,Color(1, 1, 1, 0),0.2)
	pass

var task_node = null

func SnowyBoss_died(pos : Vector2):
	var task = preload("res://Scenes/Particles/TaskParticle.tscn").instantiate()
	task.position = $Sand.position
	var area = Area2D.new()
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = 4
	area.add_child(shape)
	task.add_child(area)
	area.connect("body_entered",next_level)
	add_child(task)
	task_node = task
	MusicPlayer.stop_smooth()
	pass

func next_level(body : Node2D):
	if body.is_in_group("Player"):
		SceneTransition.change_scene("res://Levels/Level3.tscn",2.6)
		$Player.current_state = $Player.States.WIN
		if task_node:
			task_node.emitting = false
		await SceneTransition.scene_changed
		var dramatic_material = preload("res://Shaders/Dramatic.material")
		dramatic_material.set_shader_parameter("fade_range",0.0)
	pass

func _on_timer_timeout():
	var abilities = [preload("res://Scenes/Player/PoisonAbility.tscn"),preload("res://Scenes/Player/SpinAbility.tscn")]
	abilities.shuffle()
	
	var markers = $ItemsMarkers.get_children()
	markers.shuffle()
	
	var item = abilities[0]
	
	var spawn_particle = preload("res://Scenes/Particles/SpawnParticle.tscn").instantiate()
	spawn_particle.scene_to_spawn = item
	spawn_particle.position = markers[0].position
	call_deferred("add_child",spawn_particle)
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "anim":
		$CanvasLayer.layer = 0
		Screen.shake(2,0.1,20)
		$Player.set_physics_process(true)
		await get_tree().create_timer(1).timeout
		var spawn_particle = preload("res://Scenes/Particles/SpawnParticle.tscn").instantiate()
		spawn_particle.target = $Player
		spawn_particle.scene_to_spawn = preload("res://Scenes/Enemies/Shadhavar.tscn")
		spawn_particle.position = Vector2(240,136)
		add_child(spawn_particle)
	pass # Replace with function body.

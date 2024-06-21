extends CharacterBody2D

# Main Variables of the Boss
@export var speed : int = 200
@export var accel : int = 28
@export var decel : int = 35
@export_range(0, 250, 3) var health : int

# State Machine Enums
enum States {DECIDE, SHOOT, TORNADO, MOVE_ATTACK_CHARGE, MOVE_ATTACK, MOVE_ATTACK_STUN, DAMAGED, DEAD}
var current_state : States = States.DECIDE

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@export var target : Node2D

# Phases and Attack Types
var used_attacks : Dictionary = first_phase

var first_phase : Dictionary  = {
	0 : [States.SHOOT,4]
}

var second_phase : Dictionary  = {
	0 : [States.TORNADO,4],
	1 : [States.SHOOT,4],
}

var third_phase : Dictionary  = {
	0 : [States.MOVE_ATTACK_CHARGE,3],
	1 : [States.TORNADO,4],
	2 : [States.SHOOT,4],
}

# Attack Configure
var current_attack = 0
var repeated_times = 0

# Torando Configuration
var tornado_snowball : int = 10
var tornado_rotation : float = 0
var move_attack_angle : float = 0
var cell_size : int = 16

signal dying
signal dead(dead_position : Vector2)

func _ready():
	# Randomize the seeds
	randomize()
	rng.seed = randi()

func _physics_process(delta):
	
	if ![States.MOVE_ATTACK_STUN,States.DEAD].has(current_state):
		if $ShootTimer.is_stopped() && sign(target.position.x - position.x) != 0:
			$Squish/Sprite2D.scale.x = sign(target.position.x - position.x)
	
	if current_state == States.MOVE_ATTACK:
		$MoveAttackArea/CollisionShape2D.set_deferred("disabled",false)
		##$Squish/Sprite2D/SandParticle.emitting = true
	else:
		$MoveAttackArea/CollisionShape2D.set_deferred("disabled",true)
		##$Squish/Sprite2D/SandParticle.emitting = false
	
	##if current_state == States.MOVE_ATTACK_STUN:
		##$Squish/Sprite2D/StunParticle.emitting = true
	##else:
		##$Squish/Sprite2D/StunParticle.emitting = false
	
	##########################################
	## IF PLAYER DIED, STATE WILL BE DECIDE ##
	##########################################
	
	match current_state:
		
		States.DECIDE:
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
			
			# Start Tween (if the scale < (0.5 ,0.5) ) to Return the boss to the Normal Shape.
			if $Squish.scale.round() != Vector2(1,1):
				normalTween()
			
			# Configure the Phases using the Health value.
			if $SpawnTimer.is_stopped() && $DecideTimer.is_stopped():
				if health > 54:
					used_attacks = first_phase
				elif health <= 54 && health > 27:
					used_attacks = second_phase
				else:
					used_attacks = third_phase
#   			Used Attacks = {current_attack_index : [wanted_state, repeated_times]}
				if repeated_times >= used_attacks[current_attack][1]:
					repeated_times = 0
				
				# Set the state to the wanted ATTACK !
				set_state(used_attacks[current_attack][0])
		
		States.SHOOT:
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
		
		States.TORNADO:
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
		
		States.MOVE_ATTACK_CHARGE:
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
		
		States.MOVE_ATTACK:
			# Run in the Direction of the target(player)
			velocity.x = move_toward(velocity.x,(target.position - position).normalized().x * speed,accel)
			velocity.y = move_toward(velocity.y,(target.position - position).normalized().y * speed,accel)
		
		States.MOVE_ATTACK_STUN: # STUN دوخة - سقوط
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
		
		States.DAMAGED:
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
		
		States.DEAD:
			# Set the Velocity of the Boss to ZERO
			velocity_to_zero()
		
	move_and_slide()

func set_state(new_state : States):
	##if ![States.MOVE_ATTACK,States.MOVE_ATTACK_CHARGE].has(new_state):
		##RemovePalmTrees()
	
	match new_state:
		
		States.DECIDE:
			$DecideTimer.start()
		
		States.MOVE_ATTACK_CHARGE:
			##$AnimationPlayer.play("charge_move")
			##SpawnPalmTrees()
			pass
		
		States.MOVE_ATTACK:
			attackTween()
			$MoveAttackDelayTimer.start()
		
		States.MOVE_ATTACK_STUN:
			if $AnimationPlayer.current_animation != "stun":
				manage_attack_times()
			$StunTimer.start()
	
	current_state = new_state

func Shoot():
	match current_state:
		States.SHOOT:
			if $ShootTimer.is_stopped():
				var Snowball = preload("res://scenes/SnowyWolf/SnowBall.tscn").instantiate()
				Snowball.position = $Squish/Sprite2D/Aim.global_position
				Snowball.shooter = self
				Snowball.speed += 1
				Snowball.rotation = $"Squish/Sprite2D/Aim".global_position.angle_to_point(target.get_node("CollisionShape2D").global_position)
				get_parent().add_child(Snowball)
##				Screen.shake()
				$ShootTimer.start()
		States.TORNADO:
			if $ShootTimer.is_stopped():
				for i in tornado_snowball:
					var Snowball = preload("res://scenes/SnowyWolf/SnowBall.tscn").instantiate()
					Snowball.position = position
					Snowball.shooter = self
					Snowball.rotation = (i + 1) * deg_to_rad(360 / tornado_snowball) + tornado_rotation
					get_parent().add_child(Snowball)
##				Screen.shake()
				tornado_rotation += deg_to_rad(60)
				$ShootTimer.start()
	
	$Shoot.play()
	
	manage_attack_times()

func manage_attack_times():
	repeated_times += 1
	if repeated_times >= used_attacks[current_attack][1]:
		current_attack += 1
		if current_attack >= used_attacks.keys().size():
			current_attack = 0
		set_state(States.DECIDE)

func velocity_to_zero(weight = decel):
	velocity.x = move_toward(velocity.x,0,weight)
	velocity.y = move_toward(velocity.y,0,weight)

func _on_damage_timer_timeout():
	if [States.DEAD].has(current_state):
		return
	
	current_state = States.DECIDE

func damage(value : int = 1,knock : int = 1,angle : float = 0):
	if [States.MOVE_ATTACK_CHARGE,States.DEAD].has(current_state):
		return
	
	health -= value
	velocity = Vector2(55 * knock,0).rotated(angle)
	
	damageTween()
	
##	var damage_particle = preload("res://Scenes/Particles/DamageParticle.tscn").instantiate()
##	damage_particle.position = position
##	damage_particle.rotation_degrees = rad_to_deg(angle) + 180
##	get_parent().add_child(damage_particle)

##	Screen.shake()
##	$Hurt.play()
	
	if current_state != States.MOVE_ATTACK_STUN:
		current_state = States.DAMAGED
##		$AnimationPlayer.play("damaged")
		$ShootTimer.stop()
		$DamageTimer.start()
	
	if health <= 0:
		current_state = States.DEAD
		
		remove_from_group("Dramatic")
		
##		$AnimationPlayer.play("damaged")
		
##		Screen.slow_time()
##		Screen.shake(4,0.1,45)
		
		var flash_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		flash_tween.tween_property($Squish.material,"shader_parameter/flash_range",1.0,5)
		
		var dramatic_material = preload("res://Resources/shaders/Dramatic.material")
		
		for i in get_tree().get_nodes_in_group("Enemy"):
			if i.is_in_group("Boss"):
				continue
			i.get_node("Squish").material = dramatic_material
		
		for i in get_tree().get_nodes_in_group("Dramatic"):
			if i.get_class() != "TileMap" && i.get_class() != "Control":
				i.material = dramatic_material
			else:
				var tween_color = create_tween().set_trans(Tween.TRANS_CUBIC)
				tween_color.tween_property(i,"modulate",Color(0.25,0.25,0.25,1),5)
		
		var tween_shader = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween_shader.tween_method(func (value : float): dramatic_material.set_shader_parameter("fade_range",value),dramatic_material.get_shader_parameter("fade_range"),0.75,5)
		
		emit_signal("dying")
		
		await flash_tween.finished
		
##		Screen.shake(16,0.02)
		
##		var blood = preload("res://Scenes/Particles/BossBlood.tscn").instantiate()
##		blood.position = position
##		get_parent().add_child(blood)
		
		emit_signal("dead",position)
		
		queue_free()

func damageTween():
	var scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property($Squish,"scale",Vector2(0.75,0.75),0.05)
	scale_tween.tween_property($Squish,"scale",Vector2(1,1),0.1)
	
	var flash_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	flash_tween.tween_property($Squish.material,"shader_parameter/flash_range",1.0,0.05)
	flash_tween.tween_property($Squish.material,"shader_parameter/flash_range",0.0,0.1)

func warmupTween():
	var scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property($Squish,"scale",Vector2(1.2,0.8),0.15)

func attackTween():
	var scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property($Squish,"scale",Vector2(0.8,1.2),0.1)
	scale_tween.tween_property($Squish,"scale",Vector2(1,1),0.1)

func normalTween():
	var scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property($Squish,"scale",Vector2(1,1),0.1)

func _on_move_attack_area_body_entered(body):
	if !$MoveAttackDelayTimer.is_stopped() or current_state == States.DEAD:
		return
	
	if body.is_in_group("Damageable"):
		body.damage(3,3,(position - body.position).angle())
	
	if !body.is_in_group("Player"):
#		Screen.shake()
		pass
	set_state(States.MOVE_ATTACK_STUN)

func _on_animation_player_animation_finished(anim_name):
	if current_state == States.DEAD:
		return
	
	if anim_name == "charge_move":
		set_state(States.MOVE_ATTACK)

func _on_stun_timer_timeout():
	if current_state == States.DEAD:
		return
	set_state(States.DECIDE)

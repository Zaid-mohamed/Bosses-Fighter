class_name Frostbite extends CharacterBody2D

@export var health : int = 81
@export var max_speed : float = 300
@export var acceleration : float = 26
@export var deceleration : float = 35

@export var enemy : Node2D

# State Machine Types.
enum STATES{
DECIDE,ALERT, # التفكير ، والتنبيه 
QUICKSHOT,POWERBLAST,TWINSTRIKE,SPREADFIRE, # الحاجات اللي لها علاقة بالإطلاق 
DASHCHARGE,DASHATTACK,DASHSTUN, # هجمات الجري 
DAMAGED,FALLEN # الدامج و الموت
}

var current_state : STATES = STATES.DECIDE

var RNG : RandomNumberGenerator = RandomNumberGenerator.new()

var current_phase : Dictionary = first_phase

var first_phase : Dictionary = {
	0 : STATES.QUICKSHOT,
	1 : STATES.POWERBLAST
}

var second_phase : Dictionary = {
	0 : STATES.QUICKSHOT,
	1 : STATES.POWERBLAST,
	2 : STATES.DASHCHARGE
}

var third_phase : Dictionary = {
	0 : STATES.QUICKSHOT,
	1 : STATES.POWERBLAST,
	2 : STATES.DASHCHARGE,
	3 : STATES.TWINSTRIKE,
}

var final_phase : Dictionary = {
	0 : STATES.QUICKSHOT,
	1 : STATES.POWERBLAST,
	2 : STATES.DASHCHARGE,
	3 : STATES.TWINSTRIKE,
	4 : STATES.SPREADFIRE
}

var current_attack = 0

func _ready() -> void:
	randomize()
	RNG.seed = randi()

func _physics_process(delta: float) -> void:
	pass

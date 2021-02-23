extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")


const MAX_SPEED = 90
const ACCEL = 500
const ROLL_SPEED = 120
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var state = MOVE
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var blinkAnimation = $BlinkAnimation

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	stats.connect("no_health",self, "respawn")
	animationTree.active = true
	swordHitbox.knocback_vector = roll_vector
	
	
func respawn():
	if stats.health <= 0:
		stats.health = stats.max_health
		get_tree().reload_current_scene()
		

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
			


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knocback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL* delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO , FRICTION * delta)
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("ui_roll"):
		state= ROLL
	
	move()

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	velocity=Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func animation_finished():
	velocity = velocity * .8
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)



func _on_Hurtbox_invincibility_started():
	blinkAnimation.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")


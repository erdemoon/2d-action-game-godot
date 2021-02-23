extends KinematicBody2D

const BatDeathEffect = preload("res://Effects/BatDeathEffect.tscn")

onready var stats = $Stats
onready var playerDetection = $PlayerDetection
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var blinkAnimation = $BlinkAnimation

var velocity = Vector2.ZERO
var knocback = Vector2.ZERO

export var ACCELERATION = 300
export var FRICTION = 200
export var MAX_SPEED = 50

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knocback = knocback.move_toward(Vector2.ZERO, FRICTION * delta)
	knocback = move_and_slide(knocback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			
		WANDER:
			seek_player()
			if wanderController.time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			move_to_point(wanderController.target_position,delta)
			sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wanderController.target_position) <= 4:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			
		CHASE:
			var player = playerDetection.player
			if player != null:
				move_to_point(player.global_position,delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta *400
	velocity = move_and_slide(velocity)

func move_to_point(point,delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knocback = area.knocback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)

func DeathEffect():
	var deathEffect = BatDeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position


func _on_Stats_no_health():
	queue_free()
	DeathEffect()


func _on_Hurtbox_invincibility_started():
	blinkAnimation.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")

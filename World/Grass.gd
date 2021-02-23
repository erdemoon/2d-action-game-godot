extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
const HeartItem = preload("res://Effects/HeartItem.tscn")

var stats = PlayerStats

func grass_effect():
		var grassEffect = GrassEffect.instance()
		get_parent().add_child(grassEffect)
		grassEffect.global_position = global_position

func heart_drop():
	var heartItem = HeartItem.instance()
	var chance = ["1","2","3","4","5"]
	chance.shuffle()
	if chance.pop_front() == "1":
		get_parent().call_deferred("add_child",heartItem)
		heartItem.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	grass_effect()
	if stats.health == stats.max_health:
		pass
	else:
		heart_drop()
	queue_free()
	



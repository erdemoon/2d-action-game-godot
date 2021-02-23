extends Node2D

const ItemPickUpSound = preload("res://UI/ItemPickUpSound.tscn")

var stats = PlayerStats


func _on_ItemPickup_body_entered(body):
	var itemPickUpSound = ItemPickUpSound.instance()
	if stats.health < stats.max_health:
		stats.health += 1
		get_tree().current_scene.add_child(itemPickUpSound)
	queue_free()

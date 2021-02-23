extends Sprite



func _on_Hurtbox_area_entered(area):
	queue_free()

extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_right = bottomRight.position.x
	limit_bottom = bottomRight.position.y


func _on_PassRoomX_body_entered(body):
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x + 336
	limit_right = bottomRight.position.x +336
	limit_bottom = bottomRight.position.y


func _on_ExitRoomX_body_entered(body):
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x 
	limit_right = bottomRight.position.x
	limit_bottom = bottomRight.position.y

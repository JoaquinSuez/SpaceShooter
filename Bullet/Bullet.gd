extends Area2D


var direction
var speed


func _process(delta):
	position.x += direction * speed * delta
	if position.x < 0 or position.x > 1024:
		queue_free()

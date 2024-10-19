extends Node2D


var bullet_list = []
export var rail_list = []
# signals
signal sendRailPosition(railPosition)

func _on_character_appendBullet(bullet):
	bullet_list.append(bullet)


func _on_character_getRailPosition(railID) -> void:
	var railNode = get_node(rail_list[railID])
	emit_signal("sendRailPosition", railNode.position)

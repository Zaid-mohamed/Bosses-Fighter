extends Node2D





func _on_buttton_body_entered(body: Node2D) -> void:
	SceneChanger.change_scene("res://scenes/world/arenas/SnowyArena.tscn")

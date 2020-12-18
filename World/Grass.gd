extends Node2D

func create_grass_effect():
  var GrassEffect = load("res://Effects/GrassEffect.tscn")
  var grassEffect = GrassEffect.instance()
  var world = get_tree().current_scene
  world.add_child(grassEffect)
  grassEffect.global_position = global_position
  queue_free()

func _on_HurtBox_area_entered(area):
  create_grass_effect()
  queue_free()

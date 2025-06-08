extends CanvasLayer
	
func _transitionscene():
	$AnimationPlayer.play("disolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("disolve")

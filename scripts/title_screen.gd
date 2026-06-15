extends Stage

func _on_game_play_game(stage) -> void:
	var next_stage= stage.instantiate()
	play_next_stage.emit(next_stage)


func _on_typing_test_play_game(stage) -> void:
	var next_stage= stage.instantiate()
	play_next_stage.emit(next_stage)

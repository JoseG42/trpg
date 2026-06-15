class_name GameClass extends Noun
#playing the game will cause the game manager to change the current stage to
#the appropriate stage.
@export var stage_path: String
var stage
signal play_game

func load_game():
	stage= load(stage_path)
	play_game.emit(stage)
	print("loaded game")

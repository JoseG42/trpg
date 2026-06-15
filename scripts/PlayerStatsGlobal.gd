extends Node

var ALLTIMEBESTWPM= 0.1
var ALLTIMEWPMAVERAGE= 0.1

func save():
	var player_file= FileAccess.open("user://PlayerStats.save",FileAccess.WRITE)
	var save_dict= {
		"ALLTIMEBESTWPM": ALLTIMEBESTWPM,
		"ALLTIMEWPMAVERAGE": ALLTIMEWPMAVERAGE
	}
	var json_string= JSON.stringify(save_dict)
	player_file.store_line(json_string)

func load_p_stats():
	if not FileAccess.file_exists("user://PlayerStats.save"):
		return
	var player_file= FileAccess.open("user://PlayerStats.save",FileAccess.READ)
	while player_file.get_position()< player_file.get_length():
		var json_string= player_file. get_line()
		var json= JSON.new()
		var parse_result= json.parse(json_string)
		if not parse_result== OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var stat_data= json.data
		for i in stat_data.keys():
			set(i, stat_data[i])

func reset():
	ALLTIMEBESTWPM= 0.1
	ALLTIMEWPMAVERAGE= 0.1
	save()

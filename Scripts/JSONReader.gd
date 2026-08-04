extends Node

class_name JSONReader
static func LoadJson(path: String):
	if FileAccess.file_exists(path):
		var json_as_str = FileAccess.get_file_as_string(path)
		var data = JSON.parse_string(json_as_str)
		
		if data != null:
			return data
		else:
			print("Failed to parse json(%s)" % path)
	else:
		print("File %s doesn't existed" % path)
	return null

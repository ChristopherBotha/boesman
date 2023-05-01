extends Resource
class_name FolderListResource

@export var FolderPath : String:
	set(value):
		FolderPath = value
		load_all_resources()

var resource_type: String = "tscn"
var all_resources_dict = {}
	
func load_all_resources() -> void:
	if FolderPath:
		var folder = DirAccess.open(FolderPath)
		folder.list_dir_begin()

		var file_name = folder.get_next()
		while file_name != "":
			
			if not folder.current_is_dir():
				if file_name.get_extension() == resource_type:
					all_resources_dict[file_name.get_basename()] = load(FolderPath.path_join(file_name))
					
			file_name = folder.get_next()

		folder.list_dir_end()
	else:
		print("An error occurred when trying to access the folder.")

	
func find_index_of(resource : Resource) -> int:
	return all_resources_dict.find(resource)	

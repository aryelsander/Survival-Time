class_name UpgradeButtonData extends Resource

@export var _title_id : String
@export var _description_id: String
@export var points_data : Array[PointData]

var get_description:
	get:
		return tr(_description_id)
var get_title_id:
	get:
		return tr(_title_id)

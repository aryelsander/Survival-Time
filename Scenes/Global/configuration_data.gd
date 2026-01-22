class_name ConfigurationData extends Resource

#Volumes
static var _master_default_volume : float = 70
static var _music_default_volume : float = 70
static var _fx_default_volume : float = 70

@export var master_volume : float
@export var music_volume : float
@export var fx_volume : float

@export var is_fullscreen : bool
@export var language : String = ""

static func default() -> ConfigurationData:
	var config : ConfigurationData = ConfigurationData.new()
	#config
	config.master_volume = _master_default_volume
	config.music_volume = _music_default_volume
	config.fx_volume = _fx_default_volume
	config.is_fullscreen = false
	config.language = "en"
	return config

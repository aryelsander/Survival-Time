class_name ConfigurationData extends Resource

@export var background_music_default_volume : float
@export var fx_default_volume : float
@export var is_fullscreen : bool
@export var language : String = ""
@export var background_music_volume : float
@export var fx_volume : float

static func default() -> ConfigurationData:
	var config : ConfigurationData = ConfigurationData.new()
	config.background_music_default_volume = 100
	config.fx_default_volume = 100
	config.is_fullscreen = false
	config.language = "en"
	config.background_music_volume = 100
	config.fx_volume = 100
	return config

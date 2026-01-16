class_name TriggerProbability extends Resource

@export var trigger_datas : Array[TriggerData]

func pickup_random(shuffle: bool = false) -> TriggerData:
	var probabilities : Array[TriggerData] = trigger_datas
	if shuffle :
		probabilities.shuffle()
	return probabilities.pick_random()
	
func acumulative_method() -> Array[TriggerData]:
	var pick_number : float = randf_range(0.0000,100)
	var pickups : Array[TriggerData] = []
	for trigger in trigger_datas:
		if pick_number <= trigger.probability:
			pickups.append(trigger)
		
	return pickups

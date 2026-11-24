const Config = preload("infer_value_external_class_config.notest.gd")

static var instance := new()

var config: Config = Config.new()
var configs: Array[Config] = [Config.new()]
var count := 1

static func value(key: KeysOf[instance]) -> Infer[instance[key]]:
	return instance.get(key)

static func set_value(key: KeysOf[instance], new_value: Infer[instance[key]]) -> void:
	instance.set(key, new_value)

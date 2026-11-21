var a: int = 1

func set_value(key: KeysOf[self], value: InferValue[self[key]]) -> void:
	print(key, value)

func test():
	set_value("a", "text")

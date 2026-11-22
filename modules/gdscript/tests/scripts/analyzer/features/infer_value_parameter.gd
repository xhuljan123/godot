# `Infer[target[key]]` with an earlier parameter `target` (like a `Variant`): typed at each call from the argument passed
# for it. A struct (or dictionary literal) gives its keys, a GDScript object its member variables.
class Settings:
	var volume: float = 1.0
	var title := "Game"

func describe(target: Variant, key: KeysOf[Infer[target]], value: Infer[target[key]]) -> String:
	return "%s = %s" % [key, value]

func any_key(target: Variant, key: String, value: Infer[target[key]]) -> String:
	return "%s = %s" % [key, value]

func test():
	var settings := Settings.new()
	print(describe(settings, "volume", 0.5)) # value is a float.
	print(describe(settings, "title", "Menu")) # value is a String.
	var point: Struct[{ x: float, label: String }] = { x = 1.0, label = "origin" }
	print(describe(point, "label", "start")) # value is a String.
	print(describe({ count = 1 }, "count", 2)) # A dictionary literal is a struct too.
	var untyped = settings
	print(any_key(untyped, "anything", [1])) # The type of the target isn't known: no check.

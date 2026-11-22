# `-> Infer[source[key]]`: each call is typed as the value of `source` at the key passed for `key`.
# Inside the function, any value can be returned (the call checks it at runtime).
type Settings = Struct[{ volume: float, title: String, tags: Array[String] }]

var settings: Settings = { volume = 0.5, title = "Game", tags = ["a"] }
var a: int = 1
var b := "text"

func get_setting(key: KeysOf[Settings]) -> Infer[settings[key]]:
	return settings[key]

func get_own(key: KeysOf[self]) -> Infer[self[key]]:
	return get(key)

func get_on(target: Variant, key: KeysOf[Infer[target]]) -> Infer[target[key]]:
	return target[key]

func test():
	var volume := get_setting("volume") # A float.
	print(volume + 0.25)
	var title := get_setting("title") # A String.
	print(title.to_upper())
	var tags := get_setting("tags") # An Array[String].
	print(tags.size(), " ", tags.get_typed_builtin() == TYPE_STRING)
	var own_a := get_own("a") # An int.
	print(own_a + 1)
	var point: Struct[{ x: float, label: String }] = { x = 1.5, label = "origin" }
	var label := get_on(point, "label") # A String.
	print(label.length())

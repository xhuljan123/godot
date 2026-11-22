# `Infer[source[key]]` with a class source: `self`, a class, or a variable of a class type. The (non-static) member
# variables are the keys, like with `StructFromClass[...]`. `KeysOf[...]` of a class gives the names of its member variables.
class Settings:
	var volume: float = 1.0
	var title := "Game"
	static var count := 0 # Static variables aren't keys.

var a: int = 1
var b := "test"
var settings := Settings.new()

func set_own(key: List["a", "b"], value: Infer[self[key]]) -> String:
	set(key, value)
	return "%s = %s" % [key, get(key)]

func describe(key: KeysOf[Settings], value: Infer[Settings[key]]) -> String:
	return "%s = %s" % [key, value]

func set_setting(key: KeysOf[settings], value: Infer[settings[key]]) -> String:
	settings.set(key, value)
	return "%s = %s" % [key, settings.get(key)]

func test():
	print(set_own("a", 2)) # value is an int.
	print(set_own("b", "other")) # value is a String.
	print(describe("volume", 0.5)) # value is a float.
	print(describe("title", "Menu")) # value is a String.
	print(set_setting("volume", 0.25))
	var key: KeysOf[Settings] = "title"
	print(key)

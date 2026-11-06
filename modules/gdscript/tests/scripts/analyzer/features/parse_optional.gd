# `parseOptional(value, default_value)`: `value if value != null else default_value`, typed as `value`.
class Item:
	var name := "item"

class Weapon extends Item:
	func _init() -> void:
		name = "weapon"

const DEFAULT_NAME = "anon"
const NAME = parseOptional(null, DEFAULT_NAME) # Evaluated during analysis.

func get_nothing():
	return null

func test():
	# Built-in types are never null, so the value is returned.
	var count := 1
	print(parseOptional(count, 2))
	var ratio := 0.5
	print(parseOptional(ratio, 2)) # A constant `int` is accepted for a `float`.

	# Objects.
	var missing: Item = null
	var fallback := Item.new()
	fallback.name = "fallback"
	var picked := parseOptional(missing, fallback) # Typed as `Item`.
	print(picked.name)
	var existing := Item.new()
	existing.name = "existing"
	print(parseOptional(existing, fallback).name)
	print(parseOptional(missing, null))
	print(parseOptional(missing, Weapon.new()).name) # A subtype is fine.

	# Untyped values.
	var untyped = null
	print(parseOptional(untyped, "default"))
	print(parseOptional(get_nothing(), 5))
	var data := { "name": "Bob" }
	print(parseOptional(data.get("age"), 30))

	# Literals are typed from the value.
	var ids: Array[int] = [1, 2]
	var same_ids := parseOptional(ids, [])
	print(same_ids, " ", same_ids.get_typed_builtin() == TYPE_INT)

	# Optional struct keys: a missing key is `null`, so the default value is used,
	# and the call has the declared key type.
	var options: Struct[{ size?: int, label?: String }] = { label = "big" }
	var size := parseOptional(options.size, 10)
	var label := parseOptional(options["label"], "none")
	print(size, " ", label, " ", typeof(size) == TYPE_INT)

	print(NAME)

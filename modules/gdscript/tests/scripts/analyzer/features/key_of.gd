# `KeyOf[StructType]`: a `String` that only accepts the keys of a struct type.
type Config = Struct[{ name: String, size: int, enabled?: bool }]
type ConfigKey = KeyOf[Config]
type Point = Struct[{ x: float, y: float }]

const DEFAULT_KEY: ConfigKey = "size"

func foo(arg: KeyOf[Struct[{ foo: int, bar: String }]]) -> String:
	return arg

func first_key() -> ConfigKey:
	return "name"

func with_default(key: ConfigKey = "enabled") -> String:
	return key

func axis_value(point: Point, axis: KeyOf[Point]) -> float:
	var value: float = point[axis] # All the keys are "float", so the value is too.
	return value

func test():
	print(foo("foo"))
	print(foo("bar"))
	print(foo(&"bar")) # A constant `StringName` is converted.
	print(first_key())
	print(with_default())
	print(DEFAULT_KEY)

	var key: ConfigKey = "enabled"
	key = "name"
	print(key, " ", type_string(typeof(key)))

	var as_string: String = key # A key is a `String`.
	print(as_string.to_upper())

	var keys: Array[ConfigKey] = ["name", "size"]
	print(keys)

	var config: Config = { name = "box", size = 3 }
	for each_key in keys:
		print(each_key, " = ", config[each_key])

	print(axis_value({ x = 1.5, y = 2.0 }, "y"))

	# The keys of a struct with fewer keys are accepted.
	var name_only: KeyOf[Struct[{ name: String }]] = "name"
	key = name_only
	print(key)

	# A value that isn't known at compile time is accepted (unsafe). Function arguments are checked at runtime.
	var untyped = "bar"
	print(foo(untyped))

	var chosen: ConfigKey = "name" if keys.size() > 5 else "size"
	print(chosen)

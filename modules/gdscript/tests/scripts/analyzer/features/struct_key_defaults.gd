# Struct keys with default values: `key = value` (typed as the value) or `key: Type = value`.
# Keys can be separated by line breaks instead of commas.
type Foo = Struct[{
	bar = 1
	scale: float = 1
	test: String
}]

type Config = Struct[{ name = "default", tags: Array[String] = [], offset = { x = 0, y = 0 } }]
type WithSpread = Struct[{ ...Foo, extra = true }]

# A struct key can default to a struct literal: the missing keys use the defaults of the nested struct type.
type Inner = Struct[{ key1: int = 1 }]
type Outer = Struct[{
	bar: Inner = {}
	baz: Inner = { key1: 5 }
	qux: Inner = { key1 = 7 }
}]

const PRESET: Foo = { test = "preset" }

func describe(foo: Foo) -> String:
	return "%d %s %s" % [foo.bar, foo.scale, foo.test]

func test():
	var foo: Foo = { test = "hello" }
	print(describe(foo))
	var bar := foo.bar # Hard `int`: a missing key gives the default value, never `null`.
	print(typeof(bar) == TYPE_INT, " ", typeof(foo.scale) == TYPE_FLOAT)
	print(foo.has("bar"))
	foo.bar += 1 # Starts from the default value.
	print(foo.bar, " ", foo.has("bar"))
	print(foo["scale"])
	var other: Foo = { bar = 5, test = "x" }
	print(other.bar)

	# Array and dictionary defaults are copied on each read.
	var config: Config = {}
	print(config.name)
	config.tags.append("a")
	print(config.tags, " ", config.has("tags"))
	var tags := config.tags
	tags.append("b")
	print(tags, " ", config.tags)
	print(typeof(config.offset) == TYPE_DICTIONARY)

	# Nested struct defaults.
	var outer: Outer = {}
	print(outer.bar.key1, " ", outer.baz.key1, " ", outer.qux.key1)
	print(outer.has("bar"))

	# Spread, constants, utility types and `parseOptional()`.
	var spread: WithSpread = { test = "s" }
	print(spread.bar, " ", spread.extra)
	print(PRESET.bar, " ", PRESET["bar"])
	var partial: Partial[Foo] = {}
	print(partial.bar)
	print(parseOptional(foo.scale, 2.0))

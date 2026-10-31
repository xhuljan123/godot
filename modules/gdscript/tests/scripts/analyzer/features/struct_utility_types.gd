# `StructFromClass[ClassType]` and `Partial[StructType]`.
const Book = preload("struct_utility_types_external.notest.gd")

class Foo extends Resource:
	var foo := false # Has a default value: required key.
	var bar: String # No default value: optional key.
	static var ignored_static := 1 # Static variables are not keys.

class SpecialFoo extends Foo:
	var level := 1
	var anything # Untyped: `Variant`.

type FooData = StructFromClass[Foo]
type Config = Struct[{ name: String, size: int, nested: Struct[{ x: float }] }]
type ConfigPatch = Partial[Config]

func describe(data: FooData) -> String:
	return "foo=%s bar=%s" % [data.foo, data.bar]

func apply_patch(config: Config, patch: ConfigPatch) -> Config:
	var result: Config = config.duplicate(true)
	if patch.has("name"):
		result.name = patch.name
	if patch.has("size"):
		result.size = patch.size
	return result

func test():
	print(describe({ foo = true }))
	print(describe({ foo = false, bar = "set" }))

	var special: StructFromClass[SpecialFoo] = { foo = true, level = 3 }
	special.anything = [1, 2]
	print(special.level, " ", special.anything)

	var book: StructFromClass[Book] = { title = "GDScript" }
	print(book.title, " ", book.page_count)

	var config: Config = { name = "a", size = 1, nested = { x = 1.0 } }
	print(apply_patch(config, { size = 5 }))
	print(apply_patch(config, {}))

	# Inline usage and nesting.
	var partial_foo: Partial[StructFromClass[Foo]] = {}
	print(partial_foo.size())
	var patches: Array[Partial[Config]] = [{ name = "b" }, {}]
	print(patches.size())

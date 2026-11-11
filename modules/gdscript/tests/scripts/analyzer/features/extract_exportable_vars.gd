# `ExtractExportableVars[ClassType]`: a struct type with a required key for each `@export` variable of a class.
const Book = preload("extract_exportable_vars_external.notest.gd")

class Foo extends Resource:
	@export var foo := 1
	@export var bar: Array[int]
	var test := ['1', '2'] # Not exported: not a key.
	static var counter := 0 # Static: not a key.

class SpecialFoo extends Foo:
	@export_range(0, 10) var level := 1
	@export_storage var saved_name: String
	var cache: Dictionary # Not exported: not a key.

type FooExports = ExtractExportableVars[Foo]

func describe(data: FooExports) -> String:
	return "foo=%d bar=%s" % [data.foo, data.bar]

func test():
	var data: ExtractExportableVars[Foo] = { foo = 2, bar = [1, 2] }
	print(describe(data))
	var foo_value: int = data.foo
	var bar_value: Array[int] = data.bar
	print(foo_value, " ", bar_value)

	# Same keys and types as the explicit struct type.
	var same: Struct[{ foo: int, bar: Array[int] }] = data
	var back: ExtractExportableVars[Foo] = same
	print(back.foo)

	# Inherited exported variables are included.
	var special: ExtractExportableVars[SpecialFoo] = { foo = 3, bar = [], level = 5, saved_name = "special" }
	print(special.level, " ", special.saved_name)

	# Classes from other scripts.
	var book: ExtractExportableVars[Book] = { title = "GDScript" }
	print(book.title)

	# Works with the other struct utility types and in containers.
	var patch: Partial[ExtractExportableVars[Foo]] = { foo = 4 }
	print(patch.size())
	var key: KeysOf[ExtractExportableVars[SpecialFoo]] = "level"
	print(key)
	var list: Array[ExtractExportableVars[Foo]] = [{ foo = 1, bar = [1] }]
	print(list[0].bar)

# `StructRef`: classes constructed from a struct of their own variables.

class Foo extends StructRef:
	var foo := 1
	var bar: bool

class AllOptional extends StructRef:
	var foo := 1
	var bar := false

class Bar extends Foo:
	var name := "bar"
	var tags: Array[String]

class WithInit extends StructRef:
	var value := 0
	func _init(p_value: int) -> void:
		value = p_value * 2

func test():
	var foo := Foo.new({ foo = 22, bar = false })
	print(foo.foo, " ", foo.bar)

	# Variables without a default value are required. Missing variables with one keep their default value.
	print(Foo.new({ bar = true }).foo)
	print(Foo.new({ foo = 5, bar = true }).bar)

	# If every variable has a default value, the argument and all of its keys are optional.
	print(AllOptional.new().foo)
	print(AllOptional.new({}).foo)
	print(AllOptional.new({ bar = true }).foo)

	# Inherited classes include the variables of their base classes (and their required ones).
	var bar := Bar.new({ foo = 3, bar = true, name = "named", tags = ["a"] })
	print(bar.foo, " ", bar.name, " ", bar.tags)

	# `assign()` updates any subset of the variables.
	print(bar.assign({ name = "renamed", bar = false }))
	print(bar.name, " ", bar.bar)

	# A class with its own `_init()` keeps its own constructor.
	print(WithInit.new(21).value)

	print(foo is RefCounted)

	# A struct value with a subset of the variables is accepted if it has the required ones.
	var subset: Struct[{ bar: bool }] = { bar = true }
	print(Foo.new(subset).foo)

	# A dictionary that isn't known statically is checked at runtime.
	var data: Dictionary = { "bar": true }
	print(Foo.new(data).bar)

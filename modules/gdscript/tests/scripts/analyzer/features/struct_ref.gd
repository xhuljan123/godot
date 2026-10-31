# `StructRef`: classes constructed from a struct of their own variables.

class Foo extends StructRef:
	var foo := 1
	var bar: bool

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

	# The argument and all of its keys are optional: missing variables keep their default value.
	print(Foo.new().foo)
	print(Foo.new({}).foo)
	print(Foo.new({ bar = true }).foo)
	print(Foo.new({ foo = 5 }).bar)

	# Inherited classes include the variables of their base classes.
	var bar := Bar.new({ foo = 3, name = "named", tags = ["a"] })
	print(bar.foo, " ", bar.name, " ", bar.tags)

	# `assign()` updates any subset of the variables.
	print(bar.assign({ name = "renamed", bar = true }))
	print(bar.name, " ", bar.bar)

	# A class with its own `_init()` keeps its own constructor.
	print(WithInit.new(21).value)

	print(foo is RefCounted)

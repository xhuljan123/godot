class Foo extends Resource:
	var foo := false
	var bar: String

type FooData = StructFromClass[Foo]

func test():
	var missing: FooData = { foo = true }
	var unknown: FooData = { bar = "set", baz = 1 }
	var wrong_partial: Partial[FooData] = { foo = "text" }
	var not_a_struct: Partial[int]
	var native_class: StructFromClass[Node]
	var built_in: StructFromClass[String]

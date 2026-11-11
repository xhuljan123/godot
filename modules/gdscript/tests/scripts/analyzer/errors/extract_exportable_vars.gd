class Foo extends Resource:
	@export var foo := 1
	@export var bar: Array[int]
	var test := ['1', '2']

type FooExports = ExtractExportableVars[Foo]

func test():
	var missing: FooExports = { foo = 1 }
	var not_exported: FooExports = { foo = 1, bar = [], test = [] }
	var wrong_type: FooExports = { foo = "1", bar = [] }
	var native_class: ExtractExportableVars[Node]
	var built_in: ExtractExportableVars[int]

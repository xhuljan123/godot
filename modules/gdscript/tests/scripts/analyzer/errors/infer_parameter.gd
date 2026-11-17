func foo(arg_1: Variant, arg_2: Array[Infer[arg_1]]) -> void:
	print(arg_1, arg_2)

func same(value: Variant, other: Infer[value]) -> void:
	print(value, other)

func later(a: Array[Infer[b]], b: Variant) -> void:
	print(a, b)

func itself(a: Infer[a]) -> void:
	print(a)

func unknown(a: Variant, b: Infer[c]) -> void:
	print(a, b)

func in_struct(a: Variant, b: Struct[{ x: Infer[a] }]) -> void:
	print(a, b)

func test():
	foo(1, [1, 2, 3])
	foo(1, ["1"])
	foo(1, 1)
	same(1, "text")

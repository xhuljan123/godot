# Typed callables: `Callable[ArgType, ...]`. The signature is checked statically, at runtime it's a plain `Callable`.

type StringPrinter = Callable[String]

class Item:
	var label: String
	func _init(p_label: String) -> void:
		label = p_label

var member_callback: Callable[int, String] = func(number: int, text: String = "default") -> String:
	return "%d %s" % [number, text]

func add(a: int, b: int) -> int:
	return a + b

func takes_callback(callback: Callable[int]) -> void:
	callback.call(10)

func returns_callback() -> Callable[String]:
	return func(text: String) -> void:
		print("returned: ", text)

func alias_test(printer: StringPrinter) -> void:
	printer.call("alias")

func test():
	var foo: Callable[int, String] = func(number: int, text: String) -> void:
		print(number, " ", text)
	foo.call(1, "a")

	# Arguments with a default value in the assigned function can be omitted.
	var bar: Callable[int, String] = func(number: int, text: String = "default") -> void:
		print(number, " ", text)
	bar.call(2)
	bar.call(3, "b")
	print(member_callback.call(4))

	# Function references.
	var adder: Callable[int, int] = add
	print(adder.call(5, 6))

	# Untyped parameters accept any argument type.
	var untyped: Callable[int, float] = func(a, b) -> void:
		print(a, " ", b)
	untyped.call(1, 2.5)

	# Passing and returning typed callables.
	takes_callback(func(value: int) -> void: print("callback: ", value))
	returns_callback().call("hello")
	alias_test(func(text: String) -> void: print(text.to_upper()))

	# Empty argument list.
	var no_args: Callable[] = func() -> void: print("no args")
	no_args.call()

	# Nested and typed collection argument types.
	var nested: Callable[Array[int], Callable[int]] = func(values: Array[int], each: Callable[int]) -> void:
		for value in values:
			each.call(value)
	nested.call([7, 8], func(value: int) -> void: print("each: ", value))

	# Typed arrays of typed callables.
	var callbacks: Array[Callable[Item]] = []
	callbacks.append(func(item: Item) -> void: print("item: ", item.label))
	for callback in callbacks:
		callback.call(Item.new("sword"))

	# Plain callables are still accepted (checked at runtime).
	var plain := Callable(self, "add")
	var from_plain: Callable[int, int] = plain
	print(from_plain.call(1, 1))

	# Variables inferred with `:=` stay plain callables, so they can be reassigned with any signature.
	var inferred := func(value: int) -> void: print(value)
	inferred = func() -> void: print("reassigned")
	inferred.call()

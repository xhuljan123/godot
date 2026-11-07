# Typed callables with a return type: `Callable[ArgType, ...][ReturnType]`.
# Assigned functions must return a compatible type, and `call()` is typed as the return type.

type Formatter = Callable[int][String]

class Item:
	var label: String
	func _init(p_label: String) -> void:
		label = p_label

func double(value: int) -> int:
	return value * 2

func make_item(label: String) -> Item:
	return Item.new(label)

func apply(callback: Callable[int][int], value: int) -> int:
	return callback.call(value)

func returns_formatter() -> Formatter:
	return func(value: int) -> String: return "#%d" % value

func test():
	var foo: Callable[int, String][int] = func(number: int, text: String) -> int:
		return number + text.length()
	var result := foo.call(1, "abc") # Inferred as `int`.
	print(result, " ", typeof(result) == TYPE_INT)
	print(foo.callv([2, "ab"]))

	# Function references, parameters and return values.
	var doubler: Callable[int][int] = double
	print(apply(doubler, 4))
	print(apply(func(value: int) -> int: return value + 1, 4))
	print(returns_formatter().call(7).to_upper())

	# The result can be used with its members.
	var maker: Callable[String][Item] = make_item
	print(maker.call("sword").label)

	# Subtypes, and implicit conversions (checked and converted when `call()` returns).
	var as_object: Callable[String][RefCounted] = make_item
	print(as_object.call("shield") is Item)
	var to_float: Callable[int][float] = double
	var halved := to_float.call(3) / 4
	print(halved)

	# A `void` return type accepts any function.
	var callback: Callable[int][void] = double
	callback.call(1)

	# Typed callables returning typed callables.
	var factory: Callable[][Callable[int][int]] = func() -> Callable[int][int]: return double
	print(factory.call().call(10))

	# `Variant` return types and plain callables are accepted, and checked at runtime.
	var any_value: Callable[][int] = func() -> Variant: return 5
	print(any_value.call())
	var plain := Callable(self, "double")
	var from_plain: Callable[int][int] = plain
	print(from_plain.call(5))

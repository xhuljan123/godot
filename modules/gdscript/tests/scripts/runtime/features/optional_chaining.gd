# Optional chaining: `a?.b`, `a?.method()` and `a?.[key]` give `null` (and skip the rest of the chain) when `a` is `null`.
# `a?.[key]` also gives `null` when the key or index doesn't exist.
class Foo:
	var value := 1
	var child: Foo = null
	var calls := 0

	func do_something() -> void:
		calls += 1
		print("do_something() called")

	func get_value() -> int:
		return value

	func add(amount: int) -> void:
		value += amount

func side_effect() -> int:
	print("side_effect() called")
	return 1

func test():
	var node_ref: Foo = null
	node_ref?.do_something() # Like `if node_ref: node_ref.do_something()`.
	print(node_ref?.value)
	print(node_ref?.get_value())
	print(node_ref?.child.value) # The whole chain is skipped.

	node_ref = Foo.new()
	node_ref?.do_something()
	print(node_ref.calls)
	print(node_ref?.value)
	print(node_ref?.get_value())
	print(node_ref?.child?.value)

	node_ref.child = Foo.new()
	node_ref.child.value = 5
	print(node_ref?.child?.value)
	print(node_ref?.child.get_value())

	# The arguments aren't evaluated when the base is `null`.
	var missing: Foo = null
	missing?.add(side_effect())
	node_ref?.add(side_effect())
	print(node_ref.value)

	var list: Dictionary[String, int] = { "foo": 1, "bar": 2 }
	print(list?.["foo"])
	print(list?.["baz"])
	var maybe_list = null
	print(maybe_list?.["foo"])

	var array: Array[int] = [10, 20]
	print(array?.[1])
	print(array?.[5])
	print(array?.[-1])

	var user: Struct[{ name: String, age?: int, role = "guest" }] = { name = "Bob" }
	print(user?.["name"])
	print(user?.["age"])
	print(user?.["role"])
	print(user?.["email"])
	print(user?.name)

	var value: int = list?.["foo"]
	print(value)

# A struct key named like a member variable (`{ size: ... }`) is a key name, not a use of `self`:
# lambdas in static contexts must not be compiled as needing an instance.

type Options = Struct[{ size: int, label: String }]
type Keys = Dictionary[List["size", "label"], int]

var size := 5
var label := "member"

static func make(options: Options) -> String:
	return "%d %s" % [options.size, options.label]

static var effects: Dictionary[int, Callable] = {
	0: func () -> String:
		return make({ size: 1, label: "static" }),
	1: func () -> Callable:
		return func () -> String: return make({ size: 2, label: "nested" }),
}

static var keyed := func () -> Keys: return { size: 3, label: 4 }

static func from_static_func() -> String:
	var lambda := func () -> String: return make({ size: 6, label: "static func" })
	return lambda.call()

func test():
	print(effects[0].call())
	var nested: Callable = effects[1].call()
	print(nested.call())
	print(keyed.call())
	print(from_static_func())

	# In an instance context the struct key is still a name...
	var struct_lambda := func () -> String: return make({ size: 7, label: "instance" })
	print(struct_lambda.call())
	# ...while a plain dictionary key stays an expression reading the member.
	var plain_lambda := func () -> Dictionary: return { size: "value" }
	print(plain_lambda.call())

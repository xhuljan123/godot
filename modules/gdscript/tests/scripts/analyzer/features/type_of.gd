# `TypeOf[value]`: the type of a variable, constant, parameter, member or struct key.
var foo: String = "bar"
var bar: Struct[{ key: String, count?: int }]
var inferred := 1.5
const LIMIT = 10

var a: TypeOf[foo] # String
var b: TypeOf[bar] # Struct[{ key: String, count?: int }]
var c: TypeOf[bar.key] # String
var d: TypeOf[bar.count] # int: the declared type of the optional key.
var e: TypeOf[LIMIT] # int
type Number = TypeOf[inferred] # float

class Inner:
	var label := "inner"
	static var shared: Array[int] = [1, 2]

var inner := Inner.new()
var g: TypeOf[inner.label] # String
var h: TypeOf[Inner.shared] # Array[int]

func greet(name: String) -> String:
	return "hi " + name

var callback: TypeOf[greet] = greet # Callable[String][String]

func double(value: int) -> TypeOf[value]:
	return value * 2

func locals(value: int) -> void:
	var copy: TypeOf[value] = value + 1
	var text := "abc"
	var other: TypeOf[text] = text + "d"
	var not_assigned_yet: Node
	var same: TypeOf[not_assigned_yet] = null
	print(copy, " ", other, " ", same)

static func from_static() -> void:
	var text: TypeOf[foo] = "static"
	print(text.to_upper())

func test():
	a = "hello"
	print(a.to_upper())
	b = { key = "k" }
	print(b.key)
	c = b.key + "!"
	print(c.length())
	d = 3
	e = LIMIT * 2
	print(d + e)
	var number: Number = 2.5
	print(number / 2.0)
	g = inner.label
	print(g)
	h = Inner.shared
	h.push_back(3)
	print(h)
	print(callback.call("you"))
	print(double(21))
	locals(1)
	from_static()

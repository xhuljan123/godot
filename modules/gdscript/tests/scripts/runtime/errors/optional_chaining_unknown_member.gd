# `object?.member` gives `null` when `object` is `null`, but a member that a valid object doesn't have is an error,
# like `object.member`.
class Foo:
	var value := 1

func test():
	var foo = Foo.new()
	print(foo?.value)
	print(foo?.missing)

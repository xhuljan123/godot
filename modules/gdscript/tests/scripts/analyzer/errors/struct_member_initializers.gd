# A struct key with the same name as a member variable must not hide that member's errors.
var foo: Struct[{ bar: String }] = { bar = '1' }
var bar: Struct[{ config: Dictionary }] = {}

func test():
	var optional: Struct[{ age?: int }] = {}
	optional.age = "not an int"

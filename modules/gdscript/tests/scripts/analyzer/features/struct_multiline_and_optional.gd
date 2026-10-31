/*
 * File header block comment.
 * Spanning lines, with code-like text: func x(): pass
 */
extends RefCounted

var member: Struct[{
	name: String, /* the name */
	age?: int,
	owner?: Object,
}] = {
	name = "a",
}

/* Comment before a function. */
func make() -> Struct[{
	x: float,
	y: float
}]:
	return { x = 1.0, y = 2.0 }

func test():
	var local: Struct[{
		id: int,
		nested: Struct[{
			deep: String,
		}],
	}] = { id = 1, nested = { deep = "d" } }
	/* indented comment line */
	var a := 10 /* inline */ / 2 /* multi
	line */
	print(local.nested.deep, " ", member.name, " ", make().x, " ", a)
		/* weirdly indented comment-only line */
	if true:
		/* block comment as first thing in a block */ print("in block")
	print(member.age == null, " ", member.owner == null)
	var age = member.age
	print(age)
	var with_age: Struct[{ age?: int }] = { age = 5 }
	print(with_age.age + 1)
	print(with_age["age"])

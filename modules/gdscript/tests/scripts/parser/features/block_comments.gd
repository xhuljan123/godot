/* Block comment at the start of the file. */
/*
	Multiline
	block comment.
*/

func test():
	/* Comment-only line. */
	var x := 6 /* inline */ / /* between operands */ 2
	print(x) /* after a statement */
	/*
	 * Spanning lines inside a function.
	 */
	if x > 1:
		/* first line of a block */ print("block")
	# Line comments still work. /* not a block comment start
	print("end") # */
	print("/* not a comment */")

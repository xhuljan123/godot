func test():
	var missing := load_file("res://does_not_exist.tscn")
	var empty = load_file("")
	var no_loader := load_file("res://analyzer/errors/load_file.out")
	const MISSING = load_file("res://does_not_exist.gdshader")
	var path := "res://analyzer/errors/load_file.gd"
	const NOT_CONSTANT = load_file(path)

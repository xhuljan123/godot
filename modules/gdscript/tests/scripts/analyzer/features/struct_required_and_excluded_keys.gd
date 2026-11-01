# `Required[StructType]`, and keys to exclude with `Partial[StructType, { key }]` / `Required[StructType, { key }]`.
type Config = Struct[{ id: int, name: String, size?: int, tags?: Array[String] }]

type ConfigPatch = Partial[Config, { id }] # Everything optional except `id`.
type FullConfig = Required[Config] # Everything required.
type MostlyRequired = Required[Config, { tags }] # Everything required except `tags`.

func describe(config: FullConfig) -> String:
	return "%d %s %d %s" % [config.id, config.name, config.size, config.tags]

func patch_id(patch: ConfigPatch) -> int:
	return patch.id

func test():
	print(describe({ id = 1, name = "a", size = 2, tags = ["x"] }))
	print(patch_id({ id = 7 }))

	var mostly: MostlyRequired = { id = 2, name = "b", size = 3 }
	print(mostly.has("tags"))

	# Inline, with string keys, and multiline.
	var inline: Partial[Struct[{ a: int, b: int }], { "a" }] = { a = 1 }
	print(inline.a)
	var multiline: Required[Config, {
		size,
		tags,
	}] = { id = 3, name = "c" }
	print(multiline.name)

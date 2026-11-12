# Changelog

This file lists all changes made on the original Godot repository

## Fork additions (xhuljan123/godot) - GDScript language extensions

These features are specific to this fork and aren't part of upstream Godot. They are all statically checked
by the GDScript analyzer, so mistakes are reported in the script editor while typing. Struct-based types are
regular `Dictionary` values at runtime, and the other types compile to their base runtime types.

Table of contents:
- [Types](#types)
  - [Struct types](#struct-types-struct)
  - [Type aliases](#type-aliases-type-name--)
  - [Struct key types](#struct-key-types-fookey)
  - [Partial and Required](#partial-and-required)
  - [Omit and Pick](#omit-and-pick)
  - [StructFromClass](#structfromclass)
  - [ExtractExportableVars](#extractexportablevars)
  - [StructToVariant](#structtovariant)
  - [List](#list)
  - [KeysOf](#keysof)
  - [DictionaryWithKeys](#dictionarywithkeys)
  - [NestedArray and NestedDictionary](#nestedarray-and-nesteddictionary)
  - [Typed callables](#typed-callables-callableargsreturn)
- [Syntax](#syntax)
  - [Optional chaining](#optional-chaining-)
  - [Block comments](#block-comments--)
- [Classes](#classes)
  - [StructRef](#structref)
- [Functions](#functions)
  - [inferType](#infertype)
  - [mergeObjects](#mergeobjects)
  - [parseOptional](#parseoptional)
  - [load_file](#load_file)
- [Editor support](#editor-support)
- [Removed and renamed](#removed-and-renamed)

### Types

#### Struct types: `Struct[{ ... }]`

A typed object: a `Dictionary` with a known set of keys, each with its own type.

- `key: Type` is a required key.
- `key?: Type` is an optional key: it may be missing, and reading it when it's missing gives `null`.
- `key = value` is an optional key with a default value, typed as the value.
- `key: Type = value` is an optional key with an explicit type and a default value (`1` is stored as `1.0` for a `float`).
- Keys are separated by commas or line breaks. Names that aren't identifiers can be written as strings (`"display name": String`).
- `...OtherStruct` copies the keys of another struct type. Later keys override earlier ones.

```gdscript
type Foo = Struct[{
	bar = 1 # Optional, inferred as int.
	scale: float = 1 # Optional, explicit type (stored as 1.0).
	test: String # Required.
	note?: String # Optional, no default value (reads as null when missing).
}]

func _ready():
	var foo: Foo = { test = "hello" } # Lua style keys...
	var other: Foo = { test: "hi", bar: 5 } # ...or name keys (TypeScript style).
	print(foo.bar) # 1 (the default value, the key isn't added)
	foo.bar += 1 # Starts from the default value.
	foo.test = 3 # Error: "test" is a String.
	var missing: Foo = {} # Error: missing required key "test".
	var unknown: Foo = { test = "a", size = 2 } # Error: key "size" does not exist.
```

- A struct with more keys can be passed where a struct with fewer keys is expected (structural typing).
- Default values must be constant expressions. Array and dictionary defaults are copied on each read.
- Function arguments of a struct type are also checked at runtime, with an error that names the wrong key.
- Struct types can be used anywhere a type is expected: variables, arguments, return types, `Array[Struct[...]]`, `Dictionary[String, Struct[...]]`.

#### Type aliases: `type Name = ...`

Declares a reusable name for any type. `type` is only a keyword at the start of a class-level declaration, so it can still be used as a variable name elsewhere.

```gdscript
type Stats = Struct[{ hp: int, speed: float }]
type Ids = Array[int]
type Boss = Struct[{
	...Stats,
	phase: int,
}]

func spawn(stats: Stats, ids: Ids) -> Boss:
	return { hp = stats.hp, speed = stats.speed, phase = 1 }
```

Aliases of other scripts work through `class_name` or `preload()` (`Other.Stats`). Hover tooltips and argument hints show both the alias and the aliased type: `Stats (Struct[{ hp: int, speed: float }])`.

#### Struct key types: `Foo.key`

The type of a key of a struct type. It can be chained for nested struct types, and optional keys work too.

```gdscript
type Bar = Struct[{ foo: String, inner: Struct[{ x: float }] }]
type Foo = Bar.foo # String
type X = Bar.inner.x # float

var name: Foo = "Bob"
var inner: Bar.inner = { x = 2.0 }
```

#### Partial and Required

- `Partial[StructType]` makes every key optional.
- `Required[StructType]` makes every key required (default values no longer apply).
- An optional second argument lists keys to leave as they are: `Partial[StructType, { foo, bar }]`.

```gdscript
type Config = Struct[{ name: String, size: int, color?: Color }]

func update(patch: Partial[Config]) -> void: # { name?: String, size?: int, color?: Color }
	if patch.has("size"):
		print(patch.size)

var full: Required[Config] = { name = "a", size = 1, color = Color.RED } # "color" is required too.
var keep_name: Partial[Config, { name }] = { name = "only the name is required" }
```

#### Omit and Pick

- `Omit[StructType, { keys }]` is the struct type without the listed keys.
- `Pick[StructType, { keys }]` is the struct type with only the listed keys.

The remaining keys keep their type, optionality and default value. Listing a key that doesn't exist is an error.

```gdscript
type User = Struct[{ id: int, name: String, password: String, role = "guest" }]

type PublicUser = Omit[User, { password }] # Struct[{ id: int, name: String, role: String = "guest" }]
type UserName = Pick[User, { name }] # Struct[{ name: String }]

var foo: Omit[Struct[{ foo: int, bar: String }], { bar }] = { foo = 1 } # Struct[{ foo: int }]
var bar: Pick[Struct[{ foo: int, bar: String }], { foo }] = { foo = 1 } # Struct[{ foo: int }]
```

#### StructFromClass

`StructFromClass[ClassType]` converts the member variables of a GDScript class into a struct type (base class variables included). Variables with a default value become optional keys, variables without one are required, static variables are left out.

```gdscript
class Foo extends RefCounted:
	var foo := false # Optional key.
	var bar: String # Required key.
	static var ignored := 1 # Not a key.

func describe(data: StructFromClass[Foo]) -> String: # Struct[{ foo?: bool, bar: String }]
	return "foo=%s bar=%s" % [data.foo, data.bar]

func _ready():
	print(describe({ bar = "only bar" }))
```

#### ExtractExportableVars

`ExtractExportableVars[ClassType]` (previously `ExtractFromClass`) is a struct type with a required key for each `@export` variable of a GDScript class (any `@export_*` annotation except `@export_tool_button`), including inherited ones. Other variables are left out.

```gdscript
class Foo extends Resource:
	@export var foo := 1
	@export var bar: Array[int]
	var test := ["1", "2"] # Not exported: not a key.

func save_foo(data: ExtractExportableVars[Foo]) -> void: # Struct[{ foo: int, bar: Array[int] }]
	print(data.foo, data.bar)

func _ready():
	save_foo({ foo = 2, bar = [1, 2] })
	var patch: Partial[ExtractExportableVars[Foo]] = { foo = 3 }
```

#### StructToVariant

`StructToVariant[StructType]` keeps the same keys (and whether each one is optional), but every value is `Variant`. Useful for raw or unvalidated data.

```gdscript
type Foo = Struct[{ foo: int, bar: Array[String] }]

func load_foo(raw: StructToVariant[Foo]) -> void: # Struct[{ foo: Variant, bar: Variant }]
	print(raw.foo, raw.bar)

func _ready():
	load_foo({ foo = "1", bar = null })
```

#### List

`List[...]` only accepts the listed constant values, like a union of literal types in TypeScript (`'foo' | 'bar' | 1`).

```gdscript
type Foo = List["foo", "bar", 1]
type Direction = List["left", "right"]

func move(direction: Direction) -> void:
	print("moving ", direction)

func _ready():
	var bar: Foo = 1 # OK
	bar = "foo" # OK
	bar = 2 # Error: Cannot assign 2 as "Foo". Expected one of: "foo", "bar", 1.
	bar = "test" # Error.
	bar = [] # Error.
	move("left") # OK
	move("up") # Error.
	var counts: Dictionary[Direction, int] = { left = 1, right = 2 }
```

- The type is the common type of the values (`String` for `Direction`, so it can be used as a `String`), or `Variant` if they differ.
- A list with fewer values can be assigned to a list with more values. A plain value that isn't known at compile time is accepted, but it's unsafe; function arguments are checked at runtime.
- Exported `List` variables of strings or integers are shown as a dropdown in the Inspector, and code completion suggests the values.

#### KeysOf

`KeysOf[Source]` (previously `ListFrom`, which also replaces the removed `KeyOf`) creates a `List` from the names of an enum, the keys of a struct type (optional keys included), or the keys of a constant dictionary.

```gdscript
enum FooEnum { KEY_1, KEY_2 }
const TEST := { KEY_1 = 1, KEY_2 = "foo", KEY_3 = [] }
type StructType = Struct[{ key_1: int, key_2?: float, key_3 = 1 }]

type Bar = KeysOf[FooEnum] # List["KEY_1", "KEY_2"]
type Baz = KeysOf[TEST] # List["KEY_1", "KEY_2", "KEY_3"]
type Qux = KeysOf[StructType] # List["key_1", "key_2", "key_3"]

type Point = Struct[{ x: float, y: float }]

func axis_value(point: Point, axis: KeysOf[Point]) -> float:
	return point[axis] # Every key is a float, so the value is typed as float.
```

Native enums work too (`KeysOf[Node.ProcessMode]`). Using a key of a `KeysOf` type that doesn't exist in the struct being indexed is an error.

#### DictionaryWithKeys

`DictionaryWithKeys[Keys, ValueType]` is a dictionary that must contain every key of a list of string keys, each with a value of `ValueType` (like `Record<K, V>` in TypeScript).

```gdscript
type Foo = DictionaryWithKeys[List["foo", "bar"], int]
enum Stat { HEALTH, MANA }
type Stats = DictionaryWithKeys[KeysOf[Stat], float]

var bar: Foo = { foo = 1, bar = 2 } # OK
var a: Foo = { foo = 1 } # Error: missing required key "bar".
var b: Foo = { bar = 1 } # Error: missing required key "foo".
var c: Foo = { foo = "1", bar = 2 } # Error: "foo" should be int.
var stats: Stats = { HEALTH = 10, MANA = 5.5 }
```

A plain `Dictionary[List[...], ValueType]` only limits which keys are allowed, without requiring all of them.

#### NestedArray and NestedDictionary

`NestedArray[...]` and `NestedDictionary[...]` work like `Array` and `Dictionary`, but their element types can be typed collections. `Array` and `Dictionary` are unchanged (`Array[Array[int]]` is still an error).

```gdscript
var foo: NestedArray[Array[int]] = [[1, 2], [3]]
var bar: NestedDictionary[int, NestedDictionary[String, Array]] = { 1: { "a": [1, "x"] } }
var grid: NestedArray[NestedArray[Array[String]]] = [[["a"]]]

func _ready():
	var row: Array[int] = foo[0]
	print(foo[1][0] + 1) # 4, typed as int.
	var other: NestedArray[Array[String]] = foo # Error: the element types differ.
```

Nested literals are typed recursively. At runtime only the outer element type is checked, so `is` can't be used with nested types.

#### Typed callables: `Callable[Args][Return]`

Declares the argument types of a callable, and optionally its return type in a second pair of brackets. Assigned lambdas and functions are checked against the signature, and `call()` is checked and typed as the return type.

```gdscript
var on_hit: Callable[int, String][bool] = func(damage: int, source: String) -> bool:
	return damage > 10

var no_args: Callable[][void] = func() -> void: print("done")
var handlers: Array[Callable[int]] = []

func _ready():
	var killed: bool = on_hit.call(20, "trap")
	on_hit.call("20") # Error: argument 1 should be int.
	on_hit = func(text: String) -> bool: return true # Error: incompatible signature.
```

### Syntax

#### Optional chaining: `?.`

`a?.b`, `a?.method()` and `a?.[key]` give `null` when `a` is `null` (or a freed object), and skip the rest of the chain, including the arguments of calls.

```gdscript
var node_ref: Foo = get_node_or_null("Foo")
node_ref?.do_something() # Same as: if node_ref: node_ref.do_something()
print(node_ref?.child.value) # null if node_ref is null (the whole chain is skipped).

var list: Dictionary[String, int] = { "foo": 1, "bar": 2 }
print(list?.["foo"]) # 1
print(list?.["baz"]) # null instead of an error.

var array: Array[int] = [10, 20]
print(array?.[5]) # null instead of an out of bounds error.

var user: Struct[{ name: String, age?: int, role = "guest" }] = { name = "Bob" }
print(user?.["age"]) # null
print(user?.["role"]) # "guest" (the default value)
```

`?.` can't be used in an assignment target. A chain that can give `null` is typed as a weak type, so assigning it to a typed variable is checked at runtime.

#### Block comments: `/* */`

Comments that can span multiple lines or sit inside a line of code.

```gdscript
/*
	Multiline
	block comment.
*/
func _ready():
	var x := 6 /* inline */ / 2
```

### Classes

#### StructRef

A `RefCounted` whose script variables can be set all at once from a dictionary. If the class doesn't define `_init()`, its constructor takes an optional dictionary typed as `Partial[StructFromClass[ThisClass]]`, and `assign()` updates any subset of the variables later.

```gdscript
class Foo extends StructRef:
	var foo := 1
	var bar: bool

func _ready():
	var foo := Foo.new({ foo = 22, bar = false })
	print(foo.foo) # 22
	foo.assign({ bar = true }) # Updates only "bar".
	Foo.new({ baz = 1 }) # Error: "baz" isn't a variable of Foo.
```

### Functions

#### inferType

`inferType(value)` returns the dictionary literal unchanged, typed as a struct inferred from it: nested dictionaries become nested structs, and arrays whose elements share a type become typed arrays.

```gdscript
var player := inferType({ name: "Bob", hp: 10, tags: ["fast"] })
# Struct[{ name: String, hp: int, tags: Array[String] }]
player.hp = "full" # Error: "hp" is an int.
```

#### mergeObjects

`mergeObjects(defaults, overrides)` returns a new dictionary with the keys of both structs (values from `overrides` win), typed as a struct with the combined keys.

```gdscript
type Config = Struct[{ name: String, size: int }]
const DEFAULT_CONFIG: Config = { name: "default", size: 1 }

func make_config(options: Partial[Config]) -> Config:
	return mergeObjects(DEFAULT_CONFIG, options)

var a: Struct[{ name: String, size: int }] = { name = "a", size = 1 }
var b: Struct[{ size: int, color: Color }] = { size = 2, color = Color.RED }
var merged := mergeObjects(a, b) # Struct[{ name: String, size: int, color: Color }]
```

Both arguments must be structs (struct-typed values or dictionary literals with name keys).

#### parseOptional

`parseOptional(value, default_value)` returns `value`, or `default_value` if `value` is `null`. With an optional struct key, the result is typed as the key's declared type, and `default_value` must match it.

```gdscript
var foo: Struct[{ bar?: int }] = {}
var bar := parseOptional(foo.bar, 1) # 1, typed as int.
var wrong := parseOptional(foo.bar, "0") # Error: argument 2 should be "int".
```

#### load_file

`load_file(path)` loads a resource like `load()`, but a constant path is checked in the editor (missing file, unknown extension) and the result is typed like `preload()`, without loading anything during analysis. It can also be used in constants.

```gdscript
var scene := load_file("res://enemy.tscn") # Typed as PackedScene.
const Enemy = load_file("res://enemy.gd") # Typed as the script class: Enemy.new()
const SHADER = load_file("res://shader.gdshader")
var missing := load_file("res://missing.tscn") # Error: File "res://missing.tscn" does not exist.
```

### Editor support

- Syntax highlighting: `type` in type alias declarations uses the keyword color (like `var` and `func`). `Struct`, `Partial`, `Required`, `Omit`, `Pick`, `StructFromClass`, `ExtractExportableVars`, `StructToVariant`, `List`, `KeysOf`, `DictionaryWithKeys`, `NestedArray` and `NestedDictionary` use the base type color when followed by `[`.
- Code completion: type names, struct keys (in literals, after `.`, in `Foo.` types), `List`/`KeysOf` values in assignments and call arguments, members after `?.`.
- Hover tooltips, argument hints and the script documentation show the full types, including the aliased type of type aliases (`Foo (Struct[{ ... }])`).

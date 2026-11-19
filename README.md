## About this fork

This is a custom build of Godot Engine 4.8 (beta) that adds a set of GDScript language extensions on top of upstream Godot.
The goal is TypeScript-like static typing for GDScript: more mistakes are caught in the script editor while you type,
instead of at runtime.

Highlights:

- **Struct types and type aliases**: `type Player = Struct[{ name: String, hp?: int }]`, with required, optional and default keys.
- **Utility types**: `Partial`, `Required`, `Omit`, `Pick`, `StructFromClass`, `KeysOf`, `ValuesOf`, `DictionaryWithKeys`, `List`, `NestedArray`/`NestedDictionary`, and more.
- **Typed callables**: `Callable[int, String][bool]`, `FunctionArgType`, and `BoundCallable`.
- **Type inference**: `TypeOf[value]` and `Infer[param]`, which types a function's return value or another parameter from the arguments at each call.
- **Syntax additions**: optional chaining (`player?.stats?.hp`) and block comments.
- **New classes and functions**: `StructRef`, `Callable.bind_strict()`, `inferType()`, `mergeObjects()`, `parseOptional()`, `load_file()`.
- **Stricter checks**: an optional warning when a `match` on an enum doesn't handle every value.
- **Editor support**: syntax highlighting, code completion, hover tooltips, argument hints and generated docs for all of the above.

Struct types are plain `Dictionary` values at runtime, and the other new types compile to their regular runtime types.

See the [CHANGELOG](CHANGELOG.md) for the full list of changes, with examples.

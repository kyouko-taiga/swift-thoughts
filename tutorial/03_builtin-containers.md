# Built-in Containers

Swift comes with three built-in containers: the tuples, the arrays, the sets and the dictionaries.
These structures can be used to ease the manipulation of a program's data.

The API of Swift collections is quite big and this tutorial doesn't claim to cover it all.
Check [Swift's API Reference](https://developer.apple.com/reference/swift) for more information.

## Tuples

A tuple is a container composed of two or more values.
It can be initialized with a comma-separated list of values, enclosed in parentheses.
Tuples can be defined for any permutation of types, and for as many types as needed.
Note however that the number of values inside a tuple can never change:

```swift
let httpError = (404, "Not Found")
```

Here again, Swift's type inference makes sure the `someTuple` constant is properly typed with the tuple type `(Int, String)`.
Nevertheless, they can be explicitly typed using a comma-separated list of types, enclosed in parentheses:

```swift
let httpError: (Int, String) = (404, "Not Found")
```

The values of a tuple are accessed by suffixing a tuple expression with `.n`, where `n` is the `n`-th value of the tuple (starting at 0):

```swift
print(httpError.1)
// Prints "Not Found"
```

To make the code clearer, the values of a tuple can be labeled.
As a result, they can be accessed using their labels rather than their position in the tuple:

```swift
let httpError = (code: 404, message: "Not Found")
print(httpError.message)
// Prints "Not Found"
```

Another way to retrieve the values of a tuple is to assign them to new variables (or constants).
This process is called *decomposition*:

```swift
let (httpErrorCode, httpErrorMessage) = httpError
print(httpErrorMessage)
// Prints "Not Found"
```

If some values aren't needed, they can be ignored by using `_` when decomposing the tuple:

```swift
let (_, httpErrorMessage) = httpError
print(httpErrorMessage)
// Prints "Not Found"
```

> ❔
>
> How could we define a type for `httpError` such that the error message is optional?

## Arrays

An array is a collection of values of homogeneous type (e.g. a collection of `String` values).
They are declared with square brackets `[]`:

```swift
let pokemons = ["Bulbasaur", "Charmander", "Squirtle"]
```

Thanks to Swift's type inference, the type of the above array hasn't to be explicitly defined.
However, if the values of the array weren't known when defining the constant, it would have been necessary to explicitly type it as there wouldn't have been any way to infer the type of the array.

```swift
let pokemons: [String]
pokemons = ["Bulbasaur", "Charmander", "Squirtle"]
```

To type an array **and** initialize it as empty, one can use the following syntax:

```swift
let pokemons = [String]()
```

> Behind the scene, the above line calls an initializer of the Array<String> type, which builds an empty array of String.
> Then, Swift is able to infer the type of the rvalue and types the lvalue accordingly.

Arrays are indexed by `Int` values, starting at 0.
Their values can be accessed by subscripting the array (i.e. using the square brackets `[]`) with the desired index.
Using a negative number or an index equal to or greater than the size of the array will trigger a runtime error:

```swift
let pokemons = ["Bulbasaur", "Charmander", "Squirtle"]
print(pokemons[1])
// Prints "Charmander"

print(pokemons[3])
// Error: EXC_BAD_INSTRUCTION
```

Slices of an array can be accessed by using a range rather than an `Int` value as the index of the subscript:

```swift
print(pokemons[0 ... 1])
// Prints "["Bulbasaur", "Charmander"]"
```

Notice that in all the examples above, the array `pokemons` was declared as a constant (using the keyword `let`).
As a result, it becomes an immutable collection.
It is neither possible to add (or remove) values to it, nor to change the value at a given index:

```swift
let pokemons = ["Bulbasaur", "Charmander", "Squirtle"]
pokemons[0] = "Pikachu"
// Error: Cannot assign through subscript: 'pokemons' is a 'let' constant
```

Mutable arrays have to be declared with the `var` keyword:

```swift
var pokemons = ["Bulbasaur", "Charmander", "Squirtle"]
pokemons[0] = "Pikachu"
print(pokemons[0])
// Prints "Pikachu"

pokemons[1 ... 2] = ["Oddish", "Pidgey"]
print(pokemons)
// Prints "["Bulbasaur", "Oddish", "Pidgey"]"
```

Inserting a new value in an array can be performed with the `Array.insert(_:at:)` function:

```swift
pokemons.insert("Oddish", at: 0)
print(pokemons)
// Prints "["Oddish", "Bulbasaur", "Oddish", "Pidgey"]"
```

Similarly, removing a value can be performed with the `Array.remove(at:)` function:

```swift
pokemons.remove(at: 1)
print(pokemons)
// Prints "["Oddish", "Oddish", "Pidgey"]"
```

> Trying to access or modify a value for an index that is outside of an array’s existing bounds will trigger a runtime error.
> Except when the array is empty, its valid indices are always comprised between 0 and the its number of elements (its `count` property) - 1.

Arrays are sequences.
Hence, they can be iterated over with a `for-in` loop:

```swift
let pokemons = ["Bulbasaur", "Charmander", "Squirtle"]
for pokemon in pokemons {
  print(pokemon)
}
// Prints "Bulbasaur"
// Prints "Charmander"
// Prints "Squirtle"
```

> It is not safe to mutate an array while enumerating it.
> If you need to remove some values according to some predicate, use `filter(_:)` instead.
> If you need to modify the values of the array at given indices, iterate over an index (with `for i in 0 ..< array.count`) rather than its elements.

## Sets

Like an array, a set is a collection of values of homogeneous type.
However, unlike arrays, they are not ordered, and can contain at most one instance of each value.
Swift doesn't have a dedicated syntax for sets.
Instead, one should explicitly type set variables (or constants):

```swift
let pokemons: Set = ["Bulbasaur", "Charmander", "Squirtle"]
```

> Notice that the only difference with The syntax to declare array is the explicit typing `: Set`.
> Behind the scenes, the type `Set` is defined so that it can be initialized with the same syntax as arrays.
> This process is called *literal initialization*.
> The explicit typing allows Swift to know it should use the initializer of `Set` rather than that of `Array`.

Should the set be declared before initialized (or initialized empty), the type of its values should also be defined explicitly:

```swift
let pokemons = Set<String>()
```

As arrays, sets are mutable if declared with `var`.
Inserting a value in the set can be done with the `Set.insert(_:)` function:

```swift
var pokemons: Set = ["Bulbasaur", "Charmander", "Squirtle"]
pokemons.insert("Pidgey")
print(pokemons.count)
// Prints 4
```

> ❔
>
> What would `print(pokemons.count)` print if we had inserted `"Bulbasaur"` rather than `"Pidgey"`?

Removing a value can be done with the `Set.remove(_:)` function:

```swift
pokemons.remove("Pidgey")
print(pokemons.count)
// Prints 3
```

> Note that `remove(_:)` doesn't do anything if the value wasn't in the set before calling it.

Like arrays, sets are sequences.
Hence, they can be iterated over with a `for-in` loop:

```swift
let pokemons: Set = ["Bulbasaur", "Charmander", "Squirtle"]
for pokemon in pokemons {
  print(pokemon)
}
// Prints "Bulbasaur"
// Prints "Charmander"
// Prints "Squirtle"
```

> ❔
>
> Is it safe to assume that the order in which elements will be iterated is the same that the order in which they were inserted?

## Dictionaries

A dictionary is an unordered collection of tuples `(K, V)` where `K` is the type of its keys, and `V` the type of its values.
Like in a set, an instance of a key may not appear more once in a dictionary.
A same value can however be associated multiple times.
Dictionaries are with a comma-separated list of of pairs `k:v` where `k` is a key of type `K` and `v` its associated value of type `V`:

```swift
let pokemonTypes = ["Bulbasaur": "Grass", "Charmander": "Fire"]
```

Should the dictionary be declared before initialized (or initialized empty), the types of its keys and values should also be defined explicitly:

```swift
let pokemonTypes = [String:String]()
```

Dictionaries are indexed by their keys.
Their values can be accessed by subscripting the dictionary (i.e. using the square brackets `[]`) with the desired key.

```swift
let pokemonTypes = ["Bulbasaur": "Grass", "Charmander": "Fire"]
print(pokemonTypes["Bulbasaur"]!)
```

Notice the suffix operator `!` after `pokemonTypes["Bulbasaur"]`.
This is because the returned values of dictionary subscripts is an optional (i.e. if the type of its keys is `K`, the return type of its subscript is `K?`).
Hence, if there's no value associated with the given key, the dictionary returns `nil`.

```swift
if let type = pokemonTypes["Squirtle"] {
  print("Squirtle has type \(type)")
} else {
  print("We don't know the type of Squirtle")
}
```

As arrays, dictionaries are mutable if declared with `var`.
Inserting (or modifying) an entry association in a dictionary can be performed with its subscript:

```swift
var pokemonTypes = ["Bulbasaur": "Grass", "Charmander": "Fire"]
pokemonTypes["Oddish"] = "Grass"
print(pokemonTypes["Oddish"]!)
// Prints "Grass"
```

Removing an entry from a dictionary boils down to setting `nil` for the desired key:

```swift
pokemonTypes["Charmander"] = nil
```

Like arrays, sets are sequences.
Hence, they can be iterated over with a `for-in` loop.
The iterated elements are tuples of key-value (i.e. tuples of type `(K, V)`):

```swift
for (pokemon, type) in pokemonTypes {
  print("\(pokemon) has type \(type)")
}
// Prints "Bulbasaur has type Grass"
// Prints "Oddish has type Grass"
```

## Exercise

For this exercise, you'll write a small database of the employee of a company and their personal information.
Each employee is identified with a unique ID, and filled a form with its address and phone number when recruited.

Define the types required to implement such database and insert some fictive employees.
Then write the code to list all employees whose phone number starts with "022".

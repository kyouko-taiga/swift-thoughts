# Built-in Containers

Swift comes with three built-in containers: the tuples, the arrays, the sets and the maps.
These structures can be used to ease the manipulation of a program's data.

The API of Swift collections is quite big and this tutorial doesn't claim to cover it all.
Check [Swift's API Reference](https://developer.apple.com/reference/swift) for more information.

## Tuples

A tuple is a container composed of two or more values.
It can be initialized with a comma-sparated list of values, enclosed in parentheses.
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

Inserting a new value in an array can be performed with the `insert(_:at:)` method:

```swift
pokemons.insert("Growlithe", at: 0)
print(pokemons)
// Prints "["Growlithe", "Bulbasaur", "Oddish", "Pidgey"]"
```

Similarly, removing a value can be performed with the `remove(at:)` method:

```swift
pokemons.remove(at: 1)
print(pokemons)
// Prints "["Growlithe", "Oddish", "Pidgey"]"
```

> Trying to access or modify a value for an index that is outside of an array’s existing bounds will trigger a runtime error.
> Except when the array is empty, its valid indices are always comprised between 0 and the its number of elements (its `count` property) - 1.

Arrays are sequences.
As a result, they can be iterated over with a `for-in` loop:

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

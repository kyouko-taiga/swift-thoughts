---
layout: page
title: Constants, Variables and Types
permalink: /tutorial/chapter-1/
---

<span class="prev">
  <a href="{{ site.baseurl }}tutorial" title="Tutorial Index">
    <span class="arrow">←</span> Index
  </a>
</span>
<hr />

## Constants and Variables

The Swift programming language distinguishes
[variables](https://en.wikipedia.org/wiki/Variable_(computer_science)) and
[constants](https://en.wikipedia.org/wiki/Constant_(computer_programming)).
Both are an association between a name and a value.
Variables can have their value modified, whereas constants cannot.

Variables are declared with the keyword `var`.
They can be affected a new value using the `=` operator.

```swift
var pokemonLevel = 1
pokemonLevel = 2
```

Constants are declared with the keyword `let`.
Unlike variables, it is not possible to assign a value to a constant after its initialization.

```swift
let pokemonSpecies = "Bulbasaur"
pokemonSpecies = "Pikachu"
// error: cannot assign to value: 'pokemonSpecies' is a 'let' constant
```

The value of variable and constants can be printed with the built-in function `print(_:)`:

```swift
var pokemonLevel = 1
print(pokemonLevel)
// 1
```

> We'll discuss functions (and methods) with their syntax and semantics at length later in this tutorial.
> For the time being, just use them as presented in the examples.

Values can be included in strings by wrapping them in within `\()`:

```swift
print("The level of my Pokemon is \(pokemonLevel).")
// The level of my Pokemon is 1.
```

From now on, we will talk about variables and constants under the denomination of "variables".

## Types

The previous examples do not specify information what can be stored in a variable or constant,
but the Swift compiler prevents putting arbitrary values in variables or constants.
For instance, it is impossible to put a floating point number into a variable that has been initialized with an integer:

```swift
var pokemonLevel = 1
pokemonLevel = 2.3
// error: cannot assign value of type 'Double' to type 'Int'
```

Swift is [strongly typed](https://en.wikipedia.org/wiki/Strong_and_weak_typing).
Every variable is given a unique [type](https://en.wikipedia.org/wiki/Type_system),
and can only store values that correspond to this type.
Weakly typed languages do not have this restriction.
Static typing also helps to ensure [type safety](https://en.wikipedia.org/wiki/Type_safety),
that prevents bugs in programs.

Type correctness is checked by the Swift compiler.
Swift ensures that each variable is unambiguously associated with a single type,
and that each operation on that variable is well defined for that type.
The language is thus said [statically typed](https://en.wikipedia.org/wiki/Type_system#STATIC).
On the contrary, a dynamically typed language performs type checking at runtime,
during the program execution.
Static typing also helps to ensure [type safety](https://en.wikipedia.org/wiki/Type_safety).

The type of a variable may not be explicit, but it always exists.
Swift provides [type inference](https://en.wikipedia.org/wiki/Type_inference).
If the compiler can infer the type of a variable (or constant) using its initialization,
it automatically associates this type with the variable.

It is sometimes necessary to explicitly specify the type of a variable, with what is called *type annotations*.
In the example below, the variable `pokemonWeight` is explicitly typed with `Double` (for double precision floating point number),
which tells Swift that it should consider it as a `Double` value:

```swift
let pokemonWeight: Double = 5.1
```

Using type annotations, it is possible to declare a constant and initialize it later.
This feature is not available in the REPL, but available in compiled code:

```swift
let pokemonWeight: Double
pokemonWeight = 5.1
// error: variables currently must have an initial value when entered at the top level of the REPL
```

<!-- Numeric types are often not precise enough.
Is the weight of my Pokemon expressed in kilograms, or in pounds?
More precise types exist to provide the [units of measurement](https://en.wikipedia.org/wiki/Units_of_measurement).
```Swift
import Foundation
let pokemonWeight = Measurement(value: 5.1, unit: UnitMass.kilograms)
``` -->


It is possible to declare multiple variables of the same type on a single line.

```swift
let x, y: Int
```

> 👎🏻 Note that this should be done sparingly and **only when the variables are clearly related**:

The type of an expression can be retrieved with the built-in function `type(of:)`:

```swift
let pokemonWeight: Double = 5.1
print(type(of: pokemonWeight))
// Double
print(type(of: "Pikachu"))
// String
```

Types are first-class citizen in Swift.
It means that they are also considered as values.
They can be assigned to variables (or constants), like any other value,
and can also be passed as parameters to the `print(_:)` or `type(of:)` functions.

```swift
let t1 = type(of: "Pikachu")
print(t1)
// String
let t2 = type(of: t1)
print(t2)
// String.Type
let t3 = type(of: t2)
print(t3)
// String.Type.Type
```

First-class types are complex.
They are covered in other parts of this tutorial.

## Optionals

Swift requires to initialize all variables (or constants) with a value,
because it does not allow them to be `nil` by default.
Allowing everywhere the [null pointer](https://en.wikipedia.org/wiki/Null_pointer) is a bad programming practice,
as it creates easily errors.

Instead, Swift provide optional types to explicitly state what can be null.
An [optional type](https://en.wikipedia.org/wiki/Option_type) denotes a value that may be present or not.
It is specified by appending the operator `?` to any type.
The original type is *wrapped* with the possibility of the `nil` value:

In the following example, since no value is provided for `x`,
the language automatically creates an initialization with the special `nil` value,
that denotes the *absence* of a value.
It is also possible to assign `nil` manually.
Values can be assigned to optionals the same way they would have been assigned to the original type.

```swift
var trainer1: String?
// trainer1: String? = nil
var trainer2: String? = nil
// trainer2: String? = nil
var trainer3: String? = "Ash"
// trainer3: String? = "Ash"
```

Optional types take part in [type safety](https://en.wikipedia.org/wiki/Type_safety).
Their use is not transparent to the programmer: it differs from non-optionals.
Assignment to another variable requires that the other variable is also an optional.

```swift
var trainer1: String? = "Ash"
// trainer1: String? = nil
var trainer2: String = trainer1
// error: value of optional type 'String?' not unwrapped; did you mean to use '!' or '?'?
var trainer3 = trainer1
// trainer3: String? = "Ash"
```

Any optional can be converted to a non-optional value using the `!` operator.
Swift returns the wrapped value if it exists,
or throws an error at runtime if the optional value is `nil`.
This operation is called *forced-unwrapping*:

```swift
var trainer1: String? = "Ash"
// trainer1: String? = "Ash"
var trainer2: String = trainer1!
// trainer2: String = "Ash"
trainer1 = nil
trainer2 = trainer1!
// fatal error: unexpectedly found nil while unwrapping an Optional value
```

> 👎 You should never force-unwrap an optional unless your algorithm makes sure it will be assigned to a value before you do it.
> We'll see a way to do that later.

Another (less common) way to define optionals is to suffix the wrapped type with the operator `!`.
Such optionals are said to be *implicitly unwrapped*.
They avoid the need to append the `!` to get the unwrapped value.

```swift
var trainer: String
let possibleTrainer: String? = "Ash"
trainer = possibleTrainer! // the ! is required
let assumedTrainer: String! = "Ash"
trainer = assumedTrainer // no need for !
```

> The following program compiles with a warning about the implicit coercion from `String?` to `Any`.
> You can safely ignore this warning for the time being.
> We'll see how to circumvent it later.

```swift
var trainer1: String? = "Ash"
print (trainer1)
```

## Tuples

A [tuple](https://en.wikipedia.org/wiki/Tuple) is a container composed of two or more values.
It is a kind of [record data structure](https://en.wikipedia.org/wiki/Record_(computer_science)).
It can be initialized with a comma-separated list of values, enclosed in parentheses.
A tuple type is a Cartesian product of as many types as needed.

```swift
let bulbasaur = (001, "Bulbasaur")
```

> Unlike some other languages, adding padding zeros doesn't have any effect in Swift.
> To seize numbers in binary, octal or hexadecimal,
> prefix your number with respectively `0b`, `0o` and `0x`.

Type inference makes sure that the `bulbasaur` constant is typed consistently with the tuple type `(Int, String)`.
Nevertheless, tuples can be explicitly typed using a comma-separated list of types, enclosed in parentheses.
This can prove useful when the variable is not initialized on declaration:

```swift
let bulbasaur: (Int, String)
bulbasaur = (001, "Bulbasaur")
```

Assignment of a tuple value to a tuple variable must be valid with respect of typing,
as all other assignments.

```swift
var pokemon = (001, "Bulbasaur")
pokemon = (002, "Ivysaur")
pokemon = ("Venusaur", 003)
// error: cannot assign value of type 'String' to type 'Int'
```

The values of a tuple are accessed by suffixing a tuple expression with `.n`,
where `n` is the `n`-th value of the tuple (starting at 0):

```swift
bulbasaur.1
// $R1: String = "Bulbasaur"
```

Tuples are an easy way to pack data together,
but relying on the position within the tuple is a bad programming practice.
To make the code clearer and less error-prone, the parts of a tuple can be labeled.
As a result, they can be accessed using their labels rather than their position in the tuple.
However, positional access is still possible, as Swift stores both the position and the label for tuples:

```swift
let bulbasaur = (number: 001, name: "Bulbasaur")
// bulbasaur: (number: Int, name: String) = {
//   id = 1
//   name = "Bulbasaur"
// }
bulbasaur.1
// $R1: String = "Bulbasaur"
bulbasaur.name
// $R2: String = "Bulbasaur"
```

> 👎 You should almost never use positional tuples. Use labeled ones instead.

Another way to retrieve the values of a tuple is to assign them to new variables (or constants).
This process is called *decomposition*:

```swift
let bulbasaur = (number: 001, name: "Bulbasaur")
let (pokemonId, pokemonName) = bulbasaur
// pokemonId: Int = 1
// pokemonName: String = "Bulbasaur"
```

If some values aren't needed, they can be explicitly ignored by using `_` when decomposing the tuple:

```swift
let bulbasaur = (number: 001, name: "Bulbasaur")
let (_, pokemonName) = pokemon
// pokemonName: String = "Bulbasaur"
```

> ❔
>
> How could we define a type for `bulbasaur` such that the name is optional?

Tuple types (as well as other types) can become quite wordy.
Thanks to type inference, defining the tuple type is implicit in most situations.
But as we have seen, explicit typing is sometimes still required.
In order to avoid writing several times the same type (at different places in the code),
it is possible to create type aliases:

```swift
typealias Species = (number: Int, name: String)
let bulbasaur: Species = (001, "Bulbasaur")
let ivysaur  : Species = (number: 002, name: "Ivysaur")
```
<!-- let venusaur : Species = (name: "Venusaur", number: 003) -->

> Notice that we can omit the labels when initializing the `bulbasaur` constant.
> This is possible only if the values are in the same order as in the tuple definition.
<!-- > We can also change the order of the labels when initializing the `venusaur` constant. -->

## Enumerations

An enumeration defines a set of possible values for a type.
It can also be named [union type](https://en.wikipedia.org/wiki/Union_type) in other programming languages.
An enumeration is used to represent types that can have a *fixed* set of possible contents.
Enumerations are not possible if the set of possible contents can be extended,
for instance by the programmer.
They must be fully defined in only one place of the soure code.

<!-- can represent very abstract concepts, like a set of possible shapes,
or more concrete data, like the possible configurations of a library. -->
An enumeration type is declared using the keyword `enum`,
and its different values with the keyword `case`:

```swift
enum SpeciesType {
  case grass
  case fire
  case water
}
```

It is also possible to declare the cases of an enumeration on a single line:

```swift
enum SpeciesType {
  case grass, fire, water
}
```

> An enumeration is a type.
> By convention, all type names start with a capital letter (`Int`, `String`, ...) and so should enumerations.
> The name of an enumeration should also be singular rather than plural,
> so that its use makes more sense in the code.

A variable of an enumeration type can only be of *one* of the enumeration cases.
Assignment is written using the qualified name of the case:

```swift
let bulbasaurSpeciesType = SpeciesType.grass
// bulbasaurSpeciesType: SpeciesType = grass
```

If the type of the variable (or constant) is explicitly defined or has already been inferred,
it is possible (and preferred) to omit the name of the enumeration:

```swift
let bulbasaurSpeciesType: SpeciesType
bulbasaurSpeciesType = .grass
// bulbasaurSpeciesType: SpeciesType = grass
```

Enumeration cases can store *associated values*.
This permits to add information to particular cases:

```swift
enum Consumable {
  case pokeball(catchRateMultiplier: Double)
  case potion(restoration: Int)
}
let ultraBall = Consumable.pokeball(catchRateMultiplier: 2)
```

Beware that the above `ultraBall` constant is of type `Consumable`.
It is thus not possible to directly consider it as a `pokeball` and access its `catchRateMultiplier`.
This tutorial explains later how to obtain such information.

```swift
ultraBall.catchRateMultiplier
// error: value of type 'Consumable' has no member 'catchRateMultiplier'
```

Enumeration types can be *recursive*.
This is very useful for naturally recursive data structures,
such as [lists](https://en.wikipedia.org/wiki/List_(abstract_data_type)) or [trees](https://en.wikipedia.org/wiki/Tree_(data_structure)).
A recursive enumeration must be prefixed with the keyword `indirect`:

```swift
indirect enum BinaryTree {
  case leaf
  case node(BinaryTree, BinaryTree)
}
let aTree : BinaryTree = .node(.leaf, .node(.leaf, .leaf))
```

> **Warning:** there is currently a bug with indirect enumerations in the REPL, but not in the Swift compiler.
> [This bug](https://bugs.swift.org/browse/SR-3972) causes an infinite recursion where there should not be.

Enumerations are a powerful tool in Swift, and there is much more to talk about.
More detailed information and examples are available in
[Apple's language guide](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html).

## Arrays

An array is a [sequence](https://en.wikipedia.org/wiki/Sequence) of values of homogeneous type (e.g. a collection of `String` values).
Arrays are declared with square brackets `[]`:

```swift
let species = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
```

Type inference considers this array as an array of tuples `(Int, String)`,
as we have put values of such tuples within.
It also handles tuples with named fields, for instance:

```swift
let species = [(number: 001, name: "Bulbasaur"), (number: 004, name: "Charmander"), (number: 007, name:"Squirtle")]
```

If the values of an array are not given on initialization,
or if the array is initially empty,
it is necessary to explicitly type the array.
This behavior is similar to the declaration of any variable,
and more precisely similar to how optionals work.

```swift
let species = []
// error: empty collection literal requires an explicit type
typealias Species = (number: Int, name: String)
let species: [Species] // not working in the REPL only
species = [(number: 001, name: "Bulbasaur"), (number: 004, name: "Charmander"), (number: 007, name:"Squirtle")]
```

An empty array can be initialized with explicit type annotation using the following syntax:

```swift
typealias Species = (number: Int, name: String)
let species = [Species]()
```

> Behind the scene, the above line calls an initializer of the Array<String> type,
> which builds an empty array of Pokemon.
> Then, the type inference is able to determine the type of the expression and thus the type of the variable.

Arrays are sequences: they are indexed by `Int` values, starting at 0.
Their values can be accessed by subscripting the array (i.e. using the square brackets `[]`) with the desired index.
Using a negative number or an index equal to or greater than the size of the array will trigger a runtime error:

```swift
let species = [(number: 001, name: "Bulbasaur"), (number: 004, name: "Charmander"), (number: 007, name: "Squirtle")]
species[1].name
// $R0: String = "Charmander"
species[3].name
// fatal error: Index out of range
```

Slices are subparts of an array. They are themselves considered as arrays.
They can be accessed using a range rather than an `Int` value as the index of the subscript:

```swift
species[0 ... 1]
// $R1: ArraySlice<(number: Int, name: String)> = 2 values {
//   [0] = {
//     id = 1
//     name = "Bulbasaur"
//   }
//   [1] = {
//     id = 4
//     name = "Charmander"
//   }
// }
species[0 ... 1][0].name
// $R2: String = "Bulbasaur"
```

The number of elements in an array is obtained by its `count` property:

```swift
species.count
// $R6: Int = 3
```

> Trying to access or modify a value for an index that is outside of an array’s existing bounds will trigger a runtime error.
> Except when the array is empty, its valid indices are always comprised between 0 and the its number of elements (its `count` property) - 1.

Notice that in all the examples above, the `species` array was declared as a constant (using the keyword `let`).
As a result, it is an immutable collection.
It is impossible to add or remove values to it, or to change the value at a given index:

```swift
let species = [(number: 001, name: "Bulbasaur"), (number: 004, name: "Charmander"), (number: 007, name: "Squirtle")]
species[0] = (number: 025, name: "Pikachu")
// error: cannot assign through subscript: 'species' is a 'let' constant
```

Mutable arrays have to be declared with the `var` keyword:

```swift
var species = [(number: 001, name: "Bulbasaur"), (number: 004, name: "Charmander"), (number: 007, name: "Squirtle")]
species[3] = (number: 025, name: "Pikachu")
species[3].name
// $R0: String = "Pikachu"
species[1 ... 2] = [(number: 043, name: "Oddish"), (number: 016, name: "Pidgey")]
species
// $R1: [(number: Int, name: String)] = 3 values {
//   [0] = {
//     id = 25
//     name = "Pikachu"
//   }
//   [1] = {
//     id = 43
//     name = "Oddish"
//   }
//   [2] = {
//     id = 16
//     name = "Pidgey"
//   }
// }
```

Inserting a new value in an array is not possible to use the subscript assignment.
Instead, the programmer must use the `Array.insert(_:at:)` function.
It inserts a new element at the position `at` and moves all remaining elements one index after:

```swift
species[3] = (number: 025, name: "Pikachu")
// fatal error: Index out of range
species.insert((number: 043, name: "Oddish"), at: 0)
species
// $R1: [(number: Int, name: String)] = 4 values {
//   [0] = {
//     id = 43
//     name = "Oddish"
//   }
//   [1] = {
//     id = 25
//     name = "Pikachu"
//   }
//   [2] = {
//     id = 43
//     name = "Oddish"
//   }
//   [3] = {
//     id = 16
//     name = "Pidgey"
//   }
// }
```

Similarly, removing a value is performed with the `Array.remove(at:)` function.
It removes the element at index `at` and moves all remaining elemennts one index before:

```swift
species.remove(at: 1)
species
// $R1: [(number: Int, name: String)] = 3 values {
//   [0] = {
//     id = 43
//     name = "Oddish"
//   }
//   [1] = {
//     id = 43
//     name = "Oddish"
//   }
//   [2] = {
//     id = 16
//     name = "Pidgey"
//   }
// }
```

## Sets

A [set](https://en.wikipedia.org/wiki/Set_(abstract_data_type)) is a collection of values of homogeneous type.
Unlike arrays, sets are not ordered, and can contain at most one instance of each value.
Swift does not provide a dedicated syntax for sets:
they are written as arrays and explicitly typed as sets.

```swift
let speciesNames: Set = ["Bulbasaur", "Charmander", "Squirtle"]
```

> Notice that the only difference with the syntax to declare an array is the explicit typing `: Set`.
> Behind the scenes, the type `Set` is defined so that it can be initialized with the same syntax as arrays.
> This process is called *literal initialization*.
> The explicit typing allows Swift to know that it must use the initializer of `Set` rather than that of `Array`.

If the set is declared before its initialization, or is initially empty,
the type of its values must also be defined explicitly.
The syntax is similar to the one used for arrays:

```swift
let speciesNames : Set<String> = []
let speciesNames = Set<String>()
```

> Notice that if we write `Set<Species>`,
> the compiler would complain about the `Species` type not conforming to the `Hashable` protocol.
> This is because the elements of a set must have some properties that our type `Species` doesn't have.
> We'll see later how we can extend a type to make it respect such properties.

As arrays, sets are immutable if declared with `let`, and mutable if declared with `var`.
They also define similar `Set.insert(_:)` and `Set.remove(_:)` functions,
and the `count` property.
A call to `remove(_:)` does not change anything if the value does not belong to the set.

```swift
var speciesNames: Set = ["Bulbasaur", "Charmander", "Squirtle"]
speciesNames.insert("Pidgey")
speciesNames.count
// $R0: Int = 4
speciesNames.remove("Pidgey")
speciesNames.count
// $R0: Int = 3
```

> ❔
>
> What does `speciesNames.count` return if we insert `"Bulbasaur"` in the previous set?

## Dictionaries

A [dictionary](https://en.wikipedia.org/wiki/Associative_array) is a mapping from keys to values.
Each key is associated with exactly one value or nothing.
Like a set, a key cannot appear more than once in a dictionary.
A same value can however be associated with multiple keys.
Dictionaries are written as a comma-separated list of key-value pairs `k: v`,
where `k` is a key and `v` its associated value:

```swift
enum SpeciesType { case grass, fire, water }
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
```

If the dictionary is declared before its initialization, or is initially empty,
the type of its keys and values must be defined explicitly.
The syntax is similar to the one used for arrays and sets:

```swift
let speciesTypes : [String: SpeciesType] = []
let speciesTypes = [String: SpeciesType]()
```

Dictionaries are indexed by their keys.
This differs from arrays that are indexed by integers.
The values of a dictionary can be accessed by subscripting the dictionary,
using the square brackets `[]`, with the desired key.

```swift
enum SpeciesType { case grass, fire, water }
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
speciesTypes["Bulbasaur"]
// $R0: SpeciesType? = grass
```

Notice that the result is an optional.
The values returned by dictionary subscripts are optionals,
because the `nil` value is returned if the key does not exist.
This behavior differs from arrays, that raise an error in case of access outside the indices.
If the programmer knows that the key exists, the `!` operator can be used to get a non-optional value:

```swift
speciesTypes["Bulbasaur"]!
// $R0: SpeciesType = grass
```

As arrays and sets, dictionaries are mutable if declared with `var` and constants if declared with `let`.
Modification of the value associated to a key is similar to arrays and sets:

```swift
enum SpeciesType { case grass, fire, water }
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
speciesTypes["Bulbasaur"] = .water
```

Insertion and deletion differ from arrays and sets, as they are possible using subscripts:

```swift
enum SpeciesType { case grass, fire, water }
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
speciesTypes["Oddish"] = .grass
speciesTypes["Charmander"] = nil
```

## Structures

Structs are [record types](https://en.wikipedia.org/wiki/Record_type).
They allow to group together data.
They are similar to tuples with labels, but have much more powerful features that will be seen later.

A struct is declared with the keyword `struct`,
and contains typed properties declared as variables or constants:

```swift
typealias Species = (number: Int, name: String)
struct Pokemon {
  let species: Species
  var level: Int
}
```

Notice that unlike tuples, this type definition specifies whether each property is a variable or a constant.
This distinction defines what is mutable or immutable once the struct is initialized:

```swift
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
```

> Swift provides a default initializer for the `Pokemon` struct,
> as there is none explicitly defined.
> This initializer is called *memberwise initializer*,
> and requires to define values for all properties of the struct.
> We will see later how to declare custom initializers.

The `Pokemon` struct initializer is used to initialize the `rainer` variable,
which in turn initializes the properties of the struct (namely `species` and `level`).
Accessing the properties of a type instance (e.g. a struct instance) is performed using the *dot syntax*:

```swift
rainer.level
// $R0: Int = 58
```

The property `rainer.level` can be mutated, as the `rainer` is a `var` **and** the `level` property is also a `var`.
On the contrary, it is impossible to assign `rainer.specie`, because the property is a `let`,
or to assign `sparky.level`, because `sparky` is a constant.
If a struct is initialized as a constant, then none of its properties can be mutated,
no matter how they were declared:

```swift
rainer.level = rainer.level + 1
rainer.level
// $R0: Int = 59
rainer.specie = (number: 001, name: "Bulbasaur")
// error: cannot assign to property: 'specie' is a 'let' constant
sparky.level = sparky.level + 1
// error: cannot assign to property: 'sparky' is a 'let' constant
```

Note that if the instance is wrapped into an optional types,
its properties can be accessed via *optional chaining*:

```swift
var rainer: Pokemon? = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
rainer?.level
// $R0: Int? = 58
```

Notice that the return value of an optional chaining is an optional type,
wrapping the requested property.
The reason is that if the first optional is `nil`,
the result of the expression will also be `nil`,
but typed as an optional of the expected value:

```swift
rainer = nil
rainer?.level
// $R0: Int? = nil
```

Optional chaining also allows to safely assign the property of an instance wrapped in an optional.
If the value is present, its property will be set, otherwise nothing will happen.

```swift
rainer?.level = 87
// $R0: ()? = nil
```

## Classes

[Classes](https://en.wikipedia.org/wiki/Class_(computer_programming)) *look* very similar to structs,
but are actually fundamentally different.
They are declared with the same syntax but, unlike structs, do not automatically get a default initializer:

```swift
typealias Species = (number: Int, name: String)
class Pokemon {
    let species: Species
    var level: Int
    init(species: Species, level: Int) {
        self.specie = specie
        self.level = level
    }
}
```

> We will discuss initializers, together with their syntax and semantics, at length later in this tutorial.
> For the time being, just use them as presented in the examples.

One difference is easily spotted between classes and structs.
With the `Pokemon` class, it is possible to increase the `level` even on constant variables:

```swift
let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
sparky.level = sparky.level + 1
sparky.level
// $R0: Int = 32
```

This is because **classes are reference types** whereas **structs are value types**.
In other words, the constant `sparky` is a pointer to an instance of type `Pokemon`,
whereas the same using a struct is the instance itself.
While it is not possible to change the pointer value (i.e., the `sparky` constant),
it is possible to change a pointee's property (e.g., `sparky.level`)
as long as it is not itself constant.

```swift
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
sparky = rainer
// error: cannot assign to value: 'sparky' is a 'let' constant
```

Reference types allow several variables to point to the same shared class instance.
Thus, modifying a property through one variable changes the shared instance,
and thus the data seen from the other variables:

```swift
var sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
var another = sparky
sparky.level = sparky.level + 1
sparky.level
// $R0: Int = 32
another.level
// $R1: Int = 32
```

When `sparky.level` is changed, `another.level` is also mutated!
This happens because `sparky` and `another` are actually references to the same instance of `Pokemon`.
When `Pokemon` was a struct, this would not happen:

```swift
struct Pokemon { /* ... */ }
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
var another = rainer
rainer.level = rainer.level + 1
rainer.level
// $R0: Int = 59
another.level
// $R1: Int = 58
```

As classes are reference types,
it is possible to check whether two variables (or constants) refers to the same instance using the *identity operator* `===`:

```swift
class Pokemon { /* ... */ }
var sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
var another = sparky
print(sparky === another)
// $R0: Bool = true
```

As briefly illustrated above, reference types can lead to counterintuitive,
and very difficult to debug situations.
Hence, they should be avoided in Swift whenever possible.
We recommend the reader to watch the WWDC 2015 talk "[Building Better Apps with Value Types in Swift](https://www.youtube.com/watch?v=av4i3x-aZbM)"
for further discussion on the subject.

<nav id="post-nav">
  <span class="prev">
    <a href="{{ site.baseurl }}tutorial" title="Introduction">
      <span class="arrow">←</span> Introduction
    </a>
  </span>
  <span class="next">
      <a href="{{ site.baseurl }}tutorial/chapter-2" title="Chapter 2">
          Control Flow <span class="arrow">→</span>
      </a>
  </span>
</nav>

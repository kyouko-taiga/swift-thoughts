# Constants, Variables and Types

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
Unlike variables, it is not possible to assign a value to a constant after its initialization:

```swift
let pokemonSpecie = "Bulbasaur"
pokemonSpecie = "Pikachu"
// error: cannot assign to value: 'pokemonSpecie' is a 'let' constant
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

A tuple is a container composed of two or more values.
It can be initialized with a comma-separated list of values, enclosed in parentheses.
Tuples can be defined for any permutation of other types, and for as many types as needed.
Note however that the number of values inside a tuple can never change:

```swift
let bulbasaur = (001, "Bulbasaur")
```

> Unlike some other languages, adding padding zeros doesn't have any effect in Swift.
> To seize numbers in binary, octal or hexadecimal,
> prefix your number with respectively `0b`, `0o` and `0x`.

Here again, Swift's type inference makes sure the `bulbasaur` constant is properly typed with the tuple type `(Int, String)`.
Nevertheless, tuples can be explicitly typed using a comma-separated list of types, enclosed in parentheses.
This can prove useful when the variable (or constant) is not necessarily initialized when declared:

```swift
let bulbasaur: (Int, String)
bulbasaur = (001, "Bulbasaur")
```

The values of a tuple are accessed by suffixing a tuple expression with `.n`,
where `n` is the `n`-th value of the tuple (starting at 0):

```swift
print(bulbasaur.1)
// Prints "Bulbasaur"
```

To make the code clearer, the values of a tuple can be labeled.
As a result, they can be accessed using their labels rather than their position in the tuple:

```swift
let bulbasaur = (number: 001, name: "Bulbasaur")
print(bulbasaur.name)
// Prints "Bulbasaur"
```

Another way to retrieve the values of a tuple is to assign them to new variables (or constants).
This process is called *decomposition*:

```swift
let (pokemonNumber, pokemonName) = pokemon
print(pokemonName)
// Prints "Bulbasaur"
```

If some values aren't needed, they can be explicitly ignored by using `_` when decomposing the tuple:

```swift
let (_, pokemonName) = pokemon
print(pokemonName)
// Prints "Bulbasaur"
```

> ❔
>
> How could we define a type for `bulbasaur` such that the name is optional?

Tuple types (as well as other types) can become quite wordy.
Thanks to type inference, that's transparent in most situations.
But as we've seen, explicit typing is sometimes still required.
So as to avoid writing long type names in our code over and over,
It is possible to create type aliases:

```swift
typealias Species = (number: Int, name: String)

let bulbasaur: Species = (001, "Bulbasaur")
```

> Notice that we omit the labels when initializing the `bulbasaur` constant.
> This is fine because we already told Swift what the labels are,
> and since the order in which the variables of a tuples are stored never changes.
> So we still can refer to `bulbasaur.name` or `bulbasaur.1` interchangeably.

## Enumerations

An enumeration defines a a set of possible values for a type, allowing for safer and more intuitive code.
It can represent very abstract concepts, like a set of possible shapes,
or more concrete data, like the possible configurations of a library.
It is declared with the keyword `enum`, and its different values with the keyword `case`:

```swift
enum SpeciesType {
  case grass
  case fire
  case water
}
```

It is sometimes preferable to declare the cases of an enumeration on a single line:

```swift
enum SpeciesType {
  case grass, fire, water
}
```

> An enumeration is a type.
> By convention, all type names start with a capital letter (`Int`, `String`, ...) and so should enumerations.
> The name of an enumeration should also be singular rather than plural,
> so that its use makes more sense your the code.

The cases of an enumeration can be assigned to a variable (or constant),
like any other value:

```swift
let bulbasaurType = SpeciesType.grass
print(bulbasaurType)
// Prints "grass"
```

If the type of the variable (or constant) has already been inferred, or explicitly defined,
it is possible (and preferred) to omit the name of the enumeration.

```swift
let bulbasaurType: SpeciesType

bulbasaurType = .grass
// Prints "grass"
```

Enumerations can store *associated values* with one or multiple of its cases.
This permits to associate more information with a particular case:

```swift
enum Item {
  case pokeball(catchRateMultiplier: Double)
  case potion(restoration: Int)
}

let ultraBall = Consumable.pokeball(catchRateMultiplier: 2)
```

Associated values can also refer to another (or the same) case of the enumeration.
Such enumeration are said *recursive*, and prefixed with the keyword `indirect`:

```swift
indirect enum SpeciesType {
  case grass, fire, water
  case dual(primary: SpeciesType, secondary: SpeciesType)
}

let lotadType = SpeciesType.dual(primary: .water, secondary: .grass)
```

Enumerations are a powerful tool in Swift, and there would be much more to talk about.
However, as this tutorial doesn't try to be exhaustive,
we invite the reader to check [Apple's language guide](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html) for more information and/or examples.

## Arrays

An array is a collection of values of homogeneous type (e.g. a collection of `String` values).
They are declared with square brackets `[]`:

```swift
let species = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
```

Thanks to Swift's type inference, the type of the above array hasn't to be explicitly defined.
However, if the values of the array weren't known when defining the constant,
it would have been necessary to explicitly type it as there wouldn't have been any way to infer the type of the array.

```swift
let species: [Species]
species = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
```

To type an array **and** initialize it as empty, one can use the following syntax:

```swift
let species = [Species]()
```

> Behind the scene, the above line calls an initializer of the Array<String> type,
which builds an empty array of Pokemon.
> Then, Swift is able to infer the type of the rvalue and types the lvalue accordingly.

Arrays are indexed by `Int` values, starting at 0.
Their values can be accessed by subscripting the array (i.e. using the square brackets `[]`) with the desired index.
Using a negative number or an index equal to or greater than the size of the array will trigger a runtime error:

```swift
let species = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
print(species[1])
// Prints "(4, "Charmander")"

print(species[3])
// Error: EXC_BAD_INSTRUCTION
```

Slices of an array can be accessed by using a range rather than an `Int` value as the index of the subscript:

```swift
print(species[0 ... 1])
// Prints "[(1, "Bulbasaur"), (4, "Charmander")]"
```

Notice that in all the examples above, the `species` array was declared as a constant (using the keyword `let`).
As a result, it becomes an immutable collection.
It is neither possible to add (or remove) values to it, nor to change the value at a given index:

```swift
let species = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
species[0] = (025, "Pikachu")
// Error: Immutable value 'species' may not be assigned to
```

Mutable arrays have to be declared with the `var` keyword:

```swift
var species = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
species[0] = (025, "Pikachu")
print(species[0])
// Prints "(025, "Pikachu")"

species[1 ... 2] = [(043, "Oddish"), (016, "Pidgey")]
print(species)
// Prints "[(25, "Pikachu"), (43, "Oddish"), (16, "Pidgey")]"
```

Inserting a new value in an array can be performed with the `Array.insert(_:at:)` function:

```swift
species.insert((043, "Oddish"), at: 0)
print(species)
// Prints "[(43, "Oddish"), (25, "Pikachu"), (43, "Oddish"), (16, "Pidgey")]"
```

Similarly, removing a value can be performed with the `Array.remove(at:)` function:

```swift
species.remove(at: 1)
print(species)
// Prints "[(43, "Oddish"), (43, "Oddish"), (16, "Pidgey")]"
```

> Trying to access or modify a value for an index that is outside of an array’s existing bounds will trigger a runtime error.
> Except when the array is empty, its valid indices are always comprised between 0 and the its number of elements (its `count` property) - 1.

## Sets

Like an array, a set is a collection of values of homogeneous type.
However, unlike arrays, they are not ordered, and can contain at most one instance of each value.
Swift doesn't have a dedicated syntax for sets.
Instead, one should explicitly type set variables (or constants):

```swift
let speciesNames: Set = ["Bulbasaur", "Charmander", "Squirtle"]
```

> Notice that the only difference with The syntax to declare array is the explicit typing `: Set`.
> Behind the scenes, the type `Set` is defined so that it can be initialized with the same syntax as arrays.
> This process is called *literal initialization*.
> The explicit typing allows Swift to know it should use the initializer of `Set` rather than that of `Array`.

Should the set be declared before initialized (or initialized empty),
the type of its values should also be defined explicitly:

```swift
let speciesNames = Set<String>()
```

> Notice that if we were to write `Set<Species>`,
> the compiler would complain about the `Species` type not conforming to the `Hashable` protocol.
> This is because the elements of a set must have some properties that our type `Species` doesn't have.
> We'll see later how we can extend a type so it respects these kind of properties.

As arrays, sets are mutable if declared with `var`.
Inserting a value in the set can be done with the `Set.insert(_:)` function:

```swift
var speciesNames: Set = ["Bulbasaur", "Charmander", "Squirtle"]
speciesNames.insert("Pidgey")
print(speciesNames.count)
// Prints 4
```

> ❔
>
> What would `print(speciesNames.count)` print if we had inserted `"Bulbasaur"` rather than `"Pidgey"`?

Removing a value can be done with the `Set.remove(_:)` function:

```swift
speciesNames.remove("Pidgey")
print(speciesNames.count)
// Prints 3
```

> Note that `remove(_:)` doesn't do anything if the value wasn't in the set before calling it.

## Dictionaries

A dictionary is an unordered collection of tuples `(K, V)`,
where `K` is the type of its keys and `V` the type of its values.
Like in a set, an instance of a key may not appear more once in a dictionary.
A same value can however be associated multiple times.
Dictionaries are with a comma-separated list of of pairs `k: v`,
where `k` is a key of type `K` and `v` its associated value of type `V`:

```swift
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
```

Should the dictionary be declared before initialized (or initialized empty), the types of its keys and values should also be defined explicitly:

```swift
let speciesTypes = [String: SpeciesType]()
```

Dictionaries are indexed by their keys.
Their values can be accessed by subscripting the dictionary (i.e. using the square brackets `[]`) with the desired key.

```swift
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
print(speciesTypes["Bulbasaur"]!)
// Prints "grass"
```

Notice the suffix operator `!` after `speciesTypes["Bulbasaur"]`.
This is because the returned values of dictionary subscripts is an optional (i.e. if the type of its keys is `K`, the return type of its subscript is `K?`).
Hence, if there's no value associated with the given key, the dictionary returns `nil`.

As arrays, dictionaries are mutable if declared with `var`.
Inserting (or modifying) an entry association in a dictionary can be performed with its subscript:

```swift
var speciesTypes = ["Bulbasaur": "Grass", "Charmander": "Fire"]
speciesTypes["Oddish"] = .grass
print(speciesTypes["Oddish"]!)
// Prints "Grass"
```

Removing an entry from a dictionary boils down to setting `nil` for the desired key:

```swift
speciesTypes["Charmander"] = nil
```

## Structs

Struct are a general-purpose data structures that groups variables together.
In that sense, it is similar to a tuple, but we'll see later why it is much more powerful.

A struct is declared with the keyword `struct`:

```swift
struct Pokemon {
  let species: Species
  var level: Int
}
```

Notice that unlike with tuples, we specify whether the properties of a structs are variables (`var`) or constants (`let`).
This distinction defines what will or won't be mutable once our struct is initialized:

```swift
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
print(rainer)
// Prints "Pokemon(species: (134, "Vaporeon"), level: 58)"
```

> Swift provided us with a default initializer for the `Pokemon` struct,
> as we didn't declared any.
> It is called *memberwise initializer*.
> We'll see later how we can declare custom initializers.

The `Pokemon` struct initializer is used to initialize the `rainer` variable,
which in turn initializes the properties of the struct (namely `species` and `level`).
Accessing the properties of a struct instance is performed using the *dot syntax*:

```swift
print(rainer.level)
// Prints "58"
```

The property `rainer.level` can be mutated, as it is declared as a variable **and** so is `rainer`.
However, the compiler will complain when trying to assign a value to `rainer.species`,
as it is declared a constant:

```swift
rainer.level = rainer.level + 1
rainer.species = (number: 001, name: "Bulbasaur")
// Error: Cannot assign to property: 'species' is a 'let' constant
```

If a struct is initialized as a constant, then none of its properties can be mutated,
no matter how they were declared:

```swift
let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
sparky.level = sparky.level + 1
// Error: Cannot assign to property: 'sparky'  is a 'let' constant
```

## Classes

Classes *look* very similar to structs, but are actually fundamentally different.
They are declare with the same syntax.
However, unlike structs, they don't automatically get a default initializer:

```swift
class Pokemon {
    let species: Species
    var level: Int

    init(species: Species, level: Int) {
        self.species = species
        self.level = level
    }
}
```

> We'll discuss initializers with their syntax and semantics at length later in this tutorial.
> For the time being, just use them as presented in the examples.

Now that `Pokemon` is class, one very big difference can be noticed:

```swift
let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
sparky.level = sparky.level + 1
print(sparky.level)
// Prints "32"
```

The compiler now lets us assigning a value to the property `sparky.level`,
even if `sparky` is a constant.
This is because **classes are reference types** and **struct are value types**.
In other words, the constant `sparky` is like a pointer to an instance of type `Pokemon`.
While it is not possible to change the pointer value (i.e. the `sparky` constant):

```swift
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
sparky = rainer
// Error: Cannot assign to value: 'sparky' is a 'let' constant
```

it is totally fine to change a pointee's property (e.g. `sparky.level`),
as long as they are not constant themselves.

Let's consider another counterintuitive situation:

```swift
var sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
var sparky2 = sparky

sparky2.level = sparky2.level + 1
print(sparky.level)
// Prints "32"
print(sparky2.level)
// Prints "32"
```

Despite that `sparky2.level` was changed, `sparky.level` was also mutated!
This happens because `sparky` and `sparky2` are actually references to the same instance of `Pokemon`.
Back when `Pokemon` was a struct, this wouldn't have happened:

```swift
struct Pokemon { /* ... */ }

var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
var rainer2 = rainer

rainer2.level = rainer2.level + 1
print(rainer.level)
// Prints "58"
print(rainer2.level)
// Prints "59"
```

As classes are reference types,
it is possible to check whether two variables (or constants) refers to the same instance using the *identity operator* `===`:

```swift
class Pokemon { /* ... */ }

var sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
var sparky2 = sparky

print(sparky === sparky2)
// Prints "true"
```

As briefly illustrated above, reference types can lead to counterintuitive,
and very difficult to debug situations.
Hence, they should be avoided in Swift whenever possible.
We recommend the reader to watch the WWDC 2015 talk "[Building Better Apps with Value Types in Swift](https://developer.apple.com/videos/play/wwdc2015/414/)" for further discussion on the subject.

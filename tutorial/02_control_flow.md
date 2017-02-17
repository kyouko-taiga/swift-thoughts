# Control Flow

[Control flow](https://en.wikipedia.org/wiki/Control_flow) are the language constructs
that allow to change the behavior of a program depending on its data.
Swift uses `if`, `switch` or `guard` to represent conditional statements,
and `for-in`, `while` or `repeat-while` to represent loops.

## `if` statements

An `if` statement allows the program to check for a condition:

```swift
let pokemonLevel = 38

if pokemonLevel > 30 {
  print("the Pokemon won't obey")
} else {
  print("the Pokemon will obey")
}
```

Parentheses around the conditions are optional, and should not be used unless they make the code clearer.

> Unlike most languages of the C-family, Swift conditions **must** be a Boolean expression (i.e. of type `Bool`).
> As a result, `if pokemonLevel { ... }` is not be a valid expression in the above example,
> and the compiler would complain about it.

A special use of `if` is to both check if an optional variable is set (non-`nil`) and assign its value to another variable.
It is written as below:

```swift
let pokemonLevel: Int? = 38

if let level = pokemonLevel {
  print("the Pokemon level is \(level)")
} else {
  print("the Pokemon level is unknown")
}
```

Note that the above example is equivalent, but arguably clearer, than the following code.
You should use the previous variant as it is idiomatic of the Swift language.

```swift
if pokemonLevel != nil {
 print("the Pokemon level is \(pokemonLevel!)")
} else {
 print("the Pokemon level is unknown")
}
```

Another way to handle optional variables is use the infix operator `??`.
It returns its left part if it has a value, and is thus a non-optional or a non-`nil` optional;
and retuns its right part in the other cases.
This operator is used mainly to provide a default value when using optional variables:

```swift
let level = pokemonLevel ?? 1
```

When testing an enumeration variable,
it is possible to test if it is an instance of a specific `case`,
and to extract the associated properties.
You should use this construct as it is idiomatic of the Swift language:


```swift
indirect enum SpeciesType {
  // ...
  case dual(primary: SpeciesType, secondary: SpeciesType)
}
let lotadType = SpeciesType.dual(primary: .water, secondary: .grass)
if case .dual(primary: let primary, secondary: let secondary) = lotadType {
  print("Lotad has two types: \(primary) and \(secondary)")
}
// "Lotad has two types: water and grass"
```

This feature is a simplified case of [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching).
It is able to match a variety of patterns, that are presented later in this section, for instance:

```swift
let pokemon = (number: 001, name: "Bulbasaur")
if case let (number: x, name: y) = pokemon {
  print("\(y) has number \(x)")
}
if case 0 ... 10 = pokemon.number {
  print("the pokemon number is comprised between 0 and 10")
}
```

In addition to matching and extracting parts of a value,
pattern matching can also apply some conditions.
Conditions are given separated by commas, that represent an "and":

```swift
if case let (number: x, name: y) = pokemon, x > 50 {
  print("\(y) has a number greater than 50")
}
if case let x = pokemon.number, x > 50 {
  print("the pokemon number is greater than 50")
}
```

### Ternary Operator `_?_:_`

The [ternary operator](https://en.wikipedia.org/wiki/Ternary_operation) is a equivalent to an `if` in an expression.
If its first operand is true, it returns its second operand, and returns its third one otherwise:

```swift
typealias Species = (number: Int, name: String)
let pokemon = (number: 001, name: "Bulbasaur")
let another = pokemon.number == 001 ? pokemon : (number: 002, name: "Ivysaur")
```

> This operator should be used only when necessary.
> Programmers should prefer to use pattern matching instead.

## `switch` statements

A `switch` statement is a generalization of `if`.
It allows to select one among several conditions.
Contrary to the [switch statement](https://en.wikipedia.org/wiki/Switch_statement) found in many languages,
the `switch` in Swift performs pattern matching.

Pattern matching can, for instance, check that a number is within a range.
The `switch` statement works as follows:
it tests each `case` in order, from the top to the bottom,
and executes the first one that matches.
If no `case` matches the input, the `default` part is executed.

In the following example, note that cases are over range of integers.
The second `case 30 .. 100` overlaps with the first one,
but with no problem as it is tested after:

```swift
let pokemonLevel = 31
switch pokemonLevel {
  case 50 ... 100:
    print("the Pokemon won't obey unless we have 4 badges")
  case 30 ... 100:
    print("the Pokemon won't obey unless we have 2 badges")
  default:
    print("the Pokemon will obey")
}
// "the Pokemon won't obey unless we have 2 badges"
```

A `switch` statement **must** cover all possible cases.
If Swift detects missing cases, it gives an error at compile-time.

```swift
let pokemonLevel = 31
switch pokemonLevel {
  case 50 ... 100:
    print("the Pokemon won't obey unless we have 4 badges")
  case 30 ... 100:
    print("the Pokemon won't obey unless we have 2 badges")
  case 0 ... 100:
    print("the Pokemon will obey")
}
// error: switch must be exhaustive, consider adding a default clause
```

The programmer should give a `default` clause if it is difficult to describe all cases.
For instance, as the `pokemonLevel` is a integer,
the previous `switch` is complete with respect to the knowledge of the programmer (levels are between 0 and 100),
but incomplete for the Swift compiler (integers are between larger bounds).
The programmer should add a `default` clause with an assertion:

```swift
let pokemonLevel = 31
switch pokemonLevel {
  case 50 ... 100:
    print("the Pokemon won't obey unless we have 4 badges")
  case 30 ... 100:
    print("the Pokemon won't obey unless we have 2 badges")
  case 0 ... 100:
    print("the Pokemon will obey")
  default:
    assert (false)
}
```

Unlike most C-family languages, Swift does not require a `break` after each case block.
Instead, only the code explicitly written in the matched case is executed,
and the `switch` statement transfers control as soon as it's finished.
If multiple cases are handled by the same code, they are separated by a comma:

```swift
let pokemonLevel = 4
switch pokemonLevel {
  case 2, 4, 6:
    print("the Pokemon level is 2, 4 or 6")
  default:
    break
}
// "the Pokemon level is 2, 4 or 6"
```

This tutorial has already shown cases for ranges, enumerations and tuples.
All these [patterns](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html)
are available within `switch`.
More information on patterns in available [in this blog post](https://appventure.me/2015/08/20/swift-pattern-matching-in-detail/).

```swift
typealias Species = (number: Int, name: String)
struct Pokemon {
  let species: Species
  var level: Int
}

let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
switch sparky {
  case let pokemon where pokemon.species.name == "Jolteon":
    print("the Pokemon is a Jolteon with level \(pokemon.level)")
  case let pokemon where pokemon.level > 50:
    print("the Pokemon won't obey unless we have 4 badges")
  default:
    break
}
// "the Pokemon is a Jolteon"
```

```swift
indirect enum SpeciesType {
  // ...
  case dual(primary: SpeciesType, secondary: SpeciesType)
}

let lotadType = SpeciesType.dual(primary: .water, secondary: .grass)
switch lotadType {
  case .dual(primary: let primary, secondary: let secondary):
    print("the Pokemon has 2 types: \(primary) and \(secondary)")
  default:
    print("the Pokemon has 1 type: \(lotadType)")
}
// "the Pokemon has 2 types: water and grass"
```

> Unlike in pattern matching with `if-statement`,
> checking additional constraints on matched variables requires the use of the keyword `where`,
> rather than separating them with a comma:
>
> ```swift
> if case let (x, y) = someType, x > y { /* ... */ }
>
> switch someTuple {
>   case let (x, y) where x > y: /* ... */
>   default: break
> }
> ```
>
> The reason is that the comma also serves as a separator for multiple cases.

## `for-in` loops

A `for-in` loop iterates over a sequence of elements:

```swift
var speciesNames = ["Bulbasaur", "Charmander", "Squirtle"]
for i in 0 ... 2 {
  print(speciesNames[i])
}
// Bulbasaur
// Charmander
// Squirtle
```

> Notice the `0 ... 2` in the above example.
> It creates a *closed range* from 0 to 2 included.
> Swift also has another range operator, `..<`, which creates half-open ranges.
> That is `0 ..< 2` creates a range from 0 to 2 but where 2 isn't included.

The `for-in` loop can iterate over anything that is a sequence.
For instance, a character string is also a sequence of `Character`:

```swift
for character in "ヒトカゲ".characters {
  print(character)
}
// ヒ
// ト
// カ
// ゲ
```

Arrays, sets and dictionaries are also sequences.
Hence they can be iterated over with a `for-in` loop.

Iteration over arrays returns each element of the array:

```swift
typealias Species = (number: Int, name: String)
let species: [Species] = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
for oneSpecies in species {
  print(oneSpecies.name)
}
// Bulbasaur
// Charmander
// Squirtle
```

> ❔
>
> What was the advantage of explicitly typing the array in the above example?

Iteration over sets is similar to iteration over arrays.
It returns each element of the set:

```swift
let speciesNames: Set = ["Bulbasaur", "Charmander", "Squirtle", "Bulbasaur"]
for speciesName in speciesNames {
  print(speciesName)
}
// Bulbasaur
// Charmander
// Squirtle
```

Iteration over dictionaries is a bit different, as dictionaries are key-value pairs.
It thus returns pairs containing a key and its associated value (that is non `nil`):

```swift
indirect enum SpeciesType { /* ... */ }

let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
for (speciesName, speciesType) in speciesTypes {
  print("species \(speciesName) has type \(speciesType)")
}
// species Charmander has type fire
// species Bulbasaur has type grass
```

The `for-in` construct supports pattern matching, like an `if`.
Programmers can use any pattern that has been presented previously:

```swift
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
for case let (name, _) in speciesTypes where name.hasSuffix("aur") {
  print(name)
}
// Bulbasaur
```

## `while` and `repeat-while` loops

A `while` loop repeats a block of code as long as its condition holds.
The loop can thus never be executed:

```swift
let evolutions = ["Bulbasaur": "Ivysaur", "Ivysaur": "Venusaur"]
var pokemon = (level: 1, species: "Bulbasaur")
while evolutions[pokemon.species] != nil {
  pokemon = (level: pokemon.level, species: evolutions[pokemon.species]!)
}
// pokemon: (level: Int, species: String) = {
//   level = 1
//   species = "Venusaur"
// }
```

A `repeat-while` loop words similarly, but checks the condition *after* the block is executed,
rather than before.
The loop is thus executed at least once:

```swift
let evolutions = ["Bulbasaur": "Ivysaur", "Ivysaur": "Venusaur"]
var pokemon = (level: 1, species: "Bulbasaur")
repeat {
  pokemon = (level: pokemon.level, species: evolutions[pokemon.species]!)
} while evolutions[pokemon.species] != nil
// pokemon: (level: Int, species: String) = {
//   level = 1
//   species = "Venusaur"
// }
```

> ❔
>
> What happens if the list of `evolutions` is empty in the two previous loops?

The keyword `continue` skips the remainder of loop body.
It is used to force passing to the next iteration.
In the case of a `for-in` or `while` loop, the program will pass to the next iteration and then evaluate the condition,
whereas in the case of `repeat-while` loop, the program will evaluate the condition and then pass to the next iteration.

```swift
let evolutions = ["Bulbasaur": "Ivysaur", "Ivysaur": "Venusaur"]
var pokemon = (level: 1, species: "Bulbasaur")
repeat {
  if pokemon.species == "Ivysaur" {
    continue
  }
  pokemon = (level: pokemon.level, species: evolutions[pokemon.species]!)
} while evolutions[pokemon.species] != nil
// infinite loop, because the condition is always `true`
```

The keyword `break` ends the loop immediately.

```swift
let evolutions = ["Bulbasaur": "Ivysaur", "Ivysaur": "Venusaur"]
var pokemon = (level: 1, species: "Bulbasaur")
repeat {
  if pokemon.species == "Ivysaur" {
    break
  }
  pokemon = (level: pokemon.level, species: evolutions[pokemon.species]!)
} while evolutions[pokemon.species] != nil
// pokemon: (level: Int, species: String) = {
//   level = 1
//   species = "Ivysaur"
// }
```

The `continue` and `break` statements respectively skip and end the loop within which they are defined.
When nesting loops, it is sometimes desirable to perform those operation on an outer loop.
In order to do that, it is possible to label the loops, so that `continue` and `break` can specify on which loop they should be applied:

```swift
enum SpeciesType { case grass, fire, water }
struct Pokemon {
  let species: (number: Int, name: String)
  var level: Int
}
let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
let pokemons = [
  Pokemon(species: (number: 001, name: "Bulbasaur"), level: 01),
  Pokemon(species: (number: 004, name: "Charmander"), level: 01)
]
var result : Pokemon? = nil
outer: for pokemon in pokemons {
  inner: for (name, speciesType) in speciesTypes {
    if (name == pokemon.species.name) && (speciesType == .grass) {
      result = pokemon
      break outer
    }
  }
}
result
// $R0: Pokemon? = some {
//   species = {
//     number = 1
//     name = "Bulbasaur"
//   }
//   level = 1
// }
```

## `guard` statements

A `guard` statement is similar to an `if` statement, but is preferred in situations where some condition must hold for the program flow to continue:

```swift
struct Pokemon { /* ... */ }

let bulby = Pokemon(species: (number: 001, name: "Bulbasaur"), level: 8)

switch bulby {
  case let pokemon where pokemon.species.name == "Bulbasaur":
    guard pokemon.level >= 16 else {
      print("the Pokemon cannot evolve yet")
      break
    }
    print("the Pokemon can evolve")
  default:
    break
}
// the Pokemon cannot evolve yet
```

> Notice the use of the `break` keyword in the `else` clause of the guard.
> This is because `guard` should always transfer control if the condition doesn't hold,
> using `break`, `continue` or other kind of statements we'll see later.

A `guard` statement can always be replaced with an `if` statement.
Programmers should use `if` when both the "then" and "else" parts contain parts of the algorithm.
On the contrary, `guard` should be used when the algorithm only continues for the "then" part.

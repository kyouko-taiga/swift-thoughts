# Control Flow

Swift uses `if`, `switch` or `guard` to make conditional statements,
and `for-in`, `while` or `repeat-while` to make loops.
Parentheses around the conditions are optional (and shouldn't be used unless they make the code clearer).

## `if` statements

An `if` statement allows to check for a condition:

```swift
let pokemonLevel = 38

if pokemonLevel > 30 {
  print("the Pokemon won't obey")
} else {
  print("the Pokemon will obey")
}
```

> Unlike in most languages of the C-family, Swift conditions **must** be a Boolean expression (i.e. of type `Bool`).
> As a result, `if pokemonLevel { ... }` wouldn't be a valid expression in the above example, and the compiler would complain about it.

By combining an `if` and `let` together, one can also check whether an optional type is associated with a value, and assign that value to a new variable if it is.

```swift
let pokemonLevel: Int? = 38

if let level = pokemonLevel {
  print("the Pokemon level is \(level)")
} else {
  print("the Pokemon level is unknown")
}
```

Note that the above example is equivalent, but arguably clearer, than the following:

```swift
if pokemonLevel != nil {
 print("the Pokemon level is \(pokemonLevel!)")
} else {
 print("the Pokemon level is unknown")
}
```

Another way to handle optional rvalues is use the infix operator `??` to provide a default value in case it is equal to `nil`:

```swift
let level = pokemonLevel ?? 1
```

### Ternary Operator `_?_:_`

The ternary operator is a syntactic sugar for that kind of code:

```swift
let x = 11
let y: Int

if x > 10 {
  y = x / 2
} else {
  y = x * 2
}
```

With the ternary operator, the above program can be rewritten as the following:

```swift
let x = 11
let y = x > 10 ? x / 2 : x * 2
```

## `switch` statements

A `switch` statement allows to check for several *cases*.

```swift
let pokemonLevel = 51

switch pokemonLevel {
case let x where x > 50:
  print("the Pokemon won't obey unless we have 4 badges")
case let x where x > 30:
  print("the Pokemon won't obey unless we have 2 badges")
default:
  print("the Pokemon will obey")
}

// Prints "the Pokemon won't obey unless we have 4 badges"
```

If the condition is true for multiple cases, the first (from top to bottom) one "wins",
as we can see in the above example.
A `switch` statement **must** cover all possible cases.
Hence, it is often given a `default` clause which handles the cases where no other condition could be satisfied.

Notice how `let` can be used to match a pattern.
This is a very powerful feature that isn't limited to comparison between numbers:

```swift
struct Pokemon { /* ... */ }

let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)

switch sparky {
case let pokemon where pokemon.species.name == "Jolteon":
  print("the Pokemon is a Jolteon")
case let pokemon where pokemon.level > 50:
  print("the Pokemon won't obey unless we have 4 badges")
default:
  break
}

// Prints "the Pokemon is a Jolteon"
```

A `switch` statement can also be used to extract the values of an enumeration with associated values:

```swift
indirect enum SpeciesType { /* ... */ }

let lotadType = SpeciesType.dual(primary: .water, secondary: .grass)

switch lotadType {
case .dual(primary: let primary, secondary: let secondary):
  print("the Pokemon has 2 types: \(primary) and \(secondary)")
default:
  print("the Pokemon has 1 type: \(lotadType)")
}

// Prints "the Pokemon has 2 types: water and grass"
```

## `for-in` `while` and `repeat-while` loops

A `for-in` loop iterates over a sequence of elements:

```swift
for i in 0 ... 2 {
  print(i)
}
// Prints "0"
// Prints "1"
// Prints "2"
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
// Prints "ヒ"
// Prints "ト"
// Prints "カ"
// Prints "ゲ"
```

Arrays, sets and dictionaries are also sequences.
Hence they can be iterated over with a `for-in` loop:

```swift
typealias Species = (number: Int, name: String)

let species: [Species] = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]
for oneSpecies in species {
  print(oneSpecies.name)
}
// Prints "Bulbasaur"
// Prints "Charmander"
// Prints "Squirtle"
```

> ❔
>
> What was the advantage of explicitly typing the array in the above example?

Sets can be iterated similarly:

```swift
let speciesNames: Set = ["Bulbasaur", "Charmander", "Squirtle"]

for speciesName in speciesNames {
  print(speciesName)
}
// Prints "Bulbasaur"
// Prints "Charmander"
// Prints "Squirtle"
```

Dictionaries can be iterated as well.
However, unlike arrays and sets,
the iterated elements are tuples of key-value (i.e. tuples of type `(K, V)`):

```swift
indirect enum SpeciesType { /* ... */ }

let speciesTypes = ["Bulbasaur": SpeciesType.grass, "Charmander": SpeciesType.fire]
for (speciesName, speciesType) in speciesTypes {
  print("species \(speciesName) has type \(speciesType)")
}
// Prints "species Charmander has type fire"
// Prints "species Bulbasaur has type grass"
```

A `while` loop repeats a block of code as long as its condition holds:

```swift
var n = 2
while n < 100 {
  n = n * 2
}
print(n)
// Prints "128"
```

A `repeat-while` loop words similarly, but checks the condition *after* the block is executed,
rather than before:

```swift
var n = 2
repeat {
  n = n * 2
} while n < 100
print(n)
// Prints "128"
```

The keyword `continue` skips the remainder of the code in a loop.
In the case of a `for-in` loop, the program will continue for the next value of the sequence.
For the case of `while` and `repeat-while` loops, the condition will be re-evaluated:

```swift
var n = 0
while n < 6 {
    n = n + 1
    if n > 3 {
        continue
    }
    print(n)
}
// Prints "1"
// Prints "2"
// Prints "3"
```

The keyword `break` ends the loop's execution immediately and transfers the control to the next statement.

```swift
var n = 0
for i in 0 ... 10 {
  if i > 5 {
    break
  }
  n = i
}
print(n)
// Prints "5"
```

The `continue` and `break` statements respectively skip and end the loop within which they are defined.
When nesting loops, it is sometimes desirable to perform those operation on an outer loop.
In order to do that, it is possible to label the loops, so that `continue` and `break` can specify on which loop they should be applied:

```swift
outer: for x in 0 ... 3 {
    print("outer")
    inner: for y in 0 ... 3 {
        print("inner")
        if y < 2 {
            continue inner
        }

        if y > x {
            break outer
        }
    }
}
// Prints "outer"
// Prints "inner"
// Prints "inner"
// Prints "inner"
```

In the above example, the `continue` statement skips the remainder of the inner loop when `y` is smaller than 2.
As soon as `y` gets to 2, the second `if` statement is checked.
Since at `x` is equal to 0 at that particular moment, the `break` statement ends the outer loop and transfer the control to the remainder of the program.

## `guard` statements

A `guard` statement is similar to an `if` statement, but should be preferred in situations when some condition should hold for the program flow to continue:

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

// Prints "the Pokemon cannot evolve yet"
```

> Notice the use of the `break` keyword in the `else` clause of the guard.
> This is because `guard` should always transfer control if the condition doesn't hold,
> using `break`, `continue` or other kind of statements we'll see later.

A `guard` statement can always be replaced with an `if` statement.
The choice between the two depends solely on the programmer and is mostly a matter of preference.
In some situations, one might produce a code clearer than the other.

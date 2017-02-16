# Initializers

Swifts statically enforces that any variable (or constant) must be initialized before it is used.
Until now, we've been mostly using default initializers (except for classes that don't get one),
but it is also possible to define custom initializers for any structs and classes.

## Value Type Initializers

As we've seen earlier, structs receive a *memberwise initializer* if none is explicitly defined:

```swift
typealias Species = (number: Int, name: String)

struct Pokemon {
  let species: Species
  var level: Int
}

let sparky = Pokemon(species: (135, "Jolteon"), level: 31)
```

Another way to initialize a struct is to provide default values for its properties.
In that case, the struct receives a *default initializer* with no parameter:

```swift
struct Pokemon {
  let species: Species = (135, "Jolteon")
  var level = 1
}

let sparky = Pokemon()
```

> Note that by providing a default value for `Pokemon.species`,
> we actually disallow any Pokemon to have another species,
> as the constant won't never be mutable for any instance of `Pokemon`.

For a finer control on how a struct gets initialized,
Swift also allows to define custom initializers.
They have the same syntax as methods,
except that they are defined with the keyword `init` and shouldn't return anything.

```swift
struct Pokemon {
  let species: Species
  var level: Int

  init(species: Species, level: Int = 1) {
    self.species = species
    self.level = level
  }
}
```

> Note that as soon as you define a custom initializer,
> Swift doesn't provide you with neither default not memberwise initializer anymore.
> There's a current [proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0018-flexible-memberwise-initialization.md) to address this issue,
> hopefully in Swift 4 already.

Initializers can have any parameter and perform any kind of operation.
The only requirement is that they initialize **all** properties before they transfer control:

```swift
struct Pokemon {
  let species: Species
  var level: Int

  init(speciesNumber: Int, speciesName: String, level: Int = 1) {
    self.species = (number: speciesNumber, name: speciesName)
    self.level = level
  }
}

let sparky = Pokemon(speciesNumber: 135, speciesName: "Jolteon", level: 31)
```

As one would guess, `self` is mutating inside an initializer
(as otherwise the initializer wouldn't be able to initialize its values).
Nevertheless, a struct (or class) initializer can't read its properties before they are initialized:

```swift
struct Pokemon {
  let species: Species
  var level: Int

  init(speciesNumber: Int, speciesName: String, level: Int = 1) {
    self.species = (number: speciesNumber, name: speciesName)
    self.level = self.level + 1
    // Error: 'self' used before all stored properties are initialized
    self.level = level
  }
}
```

Initializers can also delegate part of all their work to other initializers:

```swift
struct Pokemon {
  let species: Species
  var level: Int

  init(species: Species, level: Int) {
    self.species = species
    self.level = level
  }

  init(speciesNumber: Int, speciesName: String, level: Int = 1) {
    self.init(species: (speciesNumber, speciesName), level)
  }
}

let sparky = Pokemon(speciesNumber: 135, speciesName: "Jolteon", level: 31)
```

> In the above example, notice that the initializer of `Pokemon` has been overloaded.
> With the addition of the default parameter on the second initializer,
> it is now possible to initialize `Pokemon` with `init(species:level:)`,
> `init(speciesNumber:speciesName:)` and `init(speciesNumber:speciesName:level:)`.

Although less common, enumerations can also define initializers.
Since enumerations can't have stored properties,
the only job of its inits initializer(s) is to provide a value for `self`:

```swift
indirect enum SpeciesType {
  case grass, fire, water
  case dual(primary: SpeciesType, secondary: SpeciesType)
  case unknown

  init(fromSpecies species: Species) {
    switch species.name {
    case "Bulbasaur":
      self = .grass
    case "Charmander":
      self = .fire
    default:
      self = .unknown
    }
  }
}

let bulbasaurType = SpeciesType(fromSpecies: (001, "Bulbasaur"))
print(bulbasaurType)
// Prints "grass"
```

> Notice that we added a case `unknown` to the enumeration,
> to handle the case we failed to match the name of the species.

## Class Initializers

Class initializers are slightly more complex than struct ones,
because unlike structs, classes can inherit from another class (and its initializers).
As we've seen earlier classes doesn't receive a memberwise initializer automatically:

```swift
class Trainer {
  let name: String
  var friends: [Trainer]

  init(name: String, friends: [Trainer]) {
    self.name = name
    self.friends = friends
  }
}

let ash = Trainer(name: "Ash", friends: [])
```

As structs they can defined any number of custom initializers,
as long as they initialize all class properties:

```swift
class Trainer {
  let name: String
  var friends: [Trainer] = []

  init(name: String) {
    self.name = name
  }

  init(name: String, bestFriend: Trainer) {
    self.name = name
    self.friends = [bestFriend]
  }
}
```

In the case of classes, this kind of initializers are said *designated*.
A big difference with structs is that a class designated initializer can't delegate to another initializer.
It has to do the initializing job by itself:

```swift
class Trainer {
  let name: String
  var friends: [Trainer] = []

  init(name: String) {
    self.name = name
  }

  init(name: String, bestFriend: Trainer) {
    self.init(name: name)
    // Error: Designated initializer for 'Trainer' cannot delegate (with 'self.init')
    self.friends = [bestFriend]
  }
}
```

Initializer delegation is still possible,
but only if we mark the initializer that delegates some work as a *convenience initializer*:

```swift
class Trainer {
  let name: String
  var friends: [Trainer] = []

  init(name: String) {
    self.name = name
  }

  convenience init(name: String, bestFriend: Trainer) {
    self.init(name: name)
    self.friends = [bestFriend]
  }
}
```

Convenience initializers aren't real initializers.
As their name suggests, they're here for convenience only,
for instance when some boilerplate often precedes the call to a designated initializer.
As a result, they can't actually initialize anything.
They just prepare some stuff buffer the actual (or rather designated) initializer is called:

```swift
class Trainer {
  let name: String
  var friends: [Trainer] = []

  init(name: String) {
    self.name = name
  }

  convenience init(name: String, bestFriend: Trainer) {
    self.friends = [bestFriend]
    // Error: Use of 'self' in property access 'friends' before self.init initializes self
    self.init(name: name)
  }
}
```

> The need for the distinction between *designated* and *convenience* initializer will be made clearer
> when we'll talk about class inheritance, later in this tutorial.

## Failable Initializers

It sometimes happens that the success or failure of a struct, class or enumeration initialization cannot be decided statically.
For instance, a struct may read its properties from an external source (like a database or an archive),
from which the data may have been corrupted.
Swift allows to declare initializers as *failable* to handle this kind of situations.
A failable initializer can either successfully initialize its type,
or "return" `nil` if the initialization failed.
They are declared by appending `?` after the `init` keyword:

```swift
let speciesList = [(001, "Bulbasaur"), (004, "Charmander"), (007, "Squirtle")]

struct Pokemon {
  let species: Species
  var level: Int

  init?(speciesNumber: Int, level: Int = 1) {
    guard let species = speciesList.first(
      where: { number, _ in number == speciesNumber }) else {
      return nil
    }

    self.species = species
    self.level = level
  }
}
```

In the above example, it is possible to instantiate `Pokemon` with a species number.
However, there's no way to ensure that the given species number is known at compile time.
Hence, the constructor is marked failable,
and a guard makes sure the species number is valid before initializing the object.

When instantiating a type with a failable initializer,
the returned object is always an optional of that type:

```swift
let bulby = Pokemon(speciesNumber: 001)
print(type(of: bulby))
// Prints "Optional<Pokemon>"
```

Enumerations can also declare a failable initializer.
This is particularly useful when there's no valid case that matches the initializer arguments.
For instance, our earlier example of initializer for `SpeciesType` could be rewritten
without the need of the additional `unknown` case:

```swift
indirect enum SpeciesType {
  case grass, fire, water
  case dual(primary: SpeciesType, secondary: SpeciesType)
  
  init(fromSpecies species: Species) {
    switch species.name {
    case "Bulbasaur":
      self = .grass
    case "Charmander":
      self = .fire
    default:
      return nil
    }
  }
}
```

> Notice that we **return** `nil` rather than assigning it to `self`.

Note that a non-failable initializer cannot delegate (neither in value types nor in classes) to a failable initializer.
A failable initializer on the other hand may do so,
and potential initialization failure will be propagated along the delegation chain.

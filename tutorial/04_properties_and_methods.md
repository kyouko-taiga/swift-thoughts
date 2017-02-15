# Properties and Methods

We've seen in chapter 1 that we can associate properties with structs and classes.
However, this wasn't the full story, as Swift properties can be more than mere constants or variables.

## Stored and Computed

Stored properties are stored as part of their struct or class.
We've seen them in action in the previous examples:

```swift
typealias Species = (number: Int, name: String)

struct Pokemon {
  let species: Species
  var level: Int
}
```

The `Pokemon` struct is declared with two stored properties.
One is a constant, the other is a variable.

Computed properties aren't stored in their struct or class.
Instead, they are *computed* every time they are get or set:

```swift
struct Pokemon {
  let species: Species
  var level: Int

  var stepsWalkedWithTrainer: Int
  var kmWalkedWithTrainer: Double {
    get {
      return Double(self.stepsWalkedWithTrainer) * 0.00076
    }

    set {
      self.stepsWalkedWithTrainer = Int(newValue * 0.00076)
    }
  }
}

var bulby = Pokemon(
  species: (001, "Bulbasaur"),
  level: 1,
  stepsWalkedWithTrainer: 600)

print(bulby.kmWalkedWithTrainer)
// Prints "0.456"
bulby.kmWalkedWithTrainer = 2.1
print(bulby.stepsWalkedWithTrainer)
// Prints "2763"
```

> In the above example, `self` is a constant that contains the value of the `Pokemon` instance.
> This variable is available to the getter and setter because they act like a method,
> which will discuss further below.

A stored property `stepsWalkedWithTrainer` has been added,
which keeps track of the number of steps a trainer walked with his/her Pokemon.
A computed property `kmWalkedWithTrainer` computes the number of kilometers it represents when accessed,
and converts back into steps when set.

Notice that the setter automatically receives an argument `newValue`.
This constant contains the new value to be assigned to the property.

If it shouldn't be (our wouldn't make sense to) set,
it is possible to omit the `get` and `set` keywords to only write the code of the getter:

```swift
struct Pokemon {
  /* ... */

  var hasReachedMaxLevel: Bool {
    return self.level == 100
  }
}
```

In the above example, a computed property `hasReachedMaxLevel` returns whether the Pokemon reached is maximum level.
The property is read-only, as it wouldn't make any sense to set it.
Indeed, what level value would be appropriate?

While enumerations can't have stored properties, they can define computed ones:

```swift
indirect enum SpeciesType {
  case grass, fire, water
  case dual(primary: SpeciesType, secondary: SpeciesType)

  var isDual: Bool {
    // Unfortunately, Swift doesn't have a syntax to return the result of this condition.
    if case .dual(primary: _, secondary: _) == self {
      return true
    }
    return false
  }
}

let lotadType = SpeciesType.dual(primary: .water, secondary: .grass)
print(lotadType.isDual)
// Prints "true"
```

## Lazy Properties

Lazy (stored) properties are similar to read-only computed properties,
but differ in the fact that they're computed only once,
and only if explicitly accessed after initialization.
Hence, they have two use-cases:

* When its value depends on something that can't be even after initialization.
* When computing its value it is expensive.

> Lazy properties are not thread safe.
> If multiple threads access it simultaneously,
> there's no mechanism to guarantee that it will be initialized only once.

The following example illustrates the second use-case,
with the assumption that the function `loadPokedexEntry(of:)` actually requires a long and expensive call to an external service.

```swift
func loadPokedexEntry(of pokemon: Pokemon) -> String {
    return "Bulbasaur, the Seed Pokemon."
}

struct Pokemon {
  /* ... */

  lazy var pokedexEntry = {
    print("loading the Pokedex entry ...")
    return loadPokedexEntry(of: self)
  }()
}

var bulby = Pokemon(
  species: (001, "Bulbasaur"),
  level: 1,
  stepsWalkedWithTrainer: 600,
  pokedexEntry: nil)

print(bulby.pokedexEntry)
// Prints "loading the Pokedex entry ..."
// Prints "the Seed Pokemon"
print(bulby.pokedexEntry)
// Prints "the Seed Pokemon"
```

Notice that another parameter appeared in the memberwise initializer.
This is because `pokedexEntry` **is** a property, and like all properties it should be initialized.
If it hadn't been initialized with `nil`,
the close associated with the lazy property would never have been called.
In the above example, it is called only once, when we first access the `pokedexEntry` property.

Note that a lazy property can't be declared a constant.
The reason is that constant properties must always have a value *before* initialization completes.
Besides, a lazy property is *mutating*,
meaning that it changes the struct (or class) it is defined in.
Indeed, it is able to modify the value it was initialized with.
As a result, it is not possible to define a lazy property that returns a closure that captures `self` in a struct.
Even if `self` isn't mutated in the closure, the problem resides in how it was captured.

```swift
struct Pokemon {
  /* ... */

  lazy var pokedexEntry: () -> String = {
    print("loading the Pokedex entry ...")
    return loadPokedexEntry(of: self)
    // Error: Closure cannot implicitly capture a mutating self parameter
  }
}
```

This would be possible if `Pokemon` was a class, as they are references.
Hence, even a constant reference doesn't prevent from modifying the class properties,
as illustrated in Chapter 1.
But there would still be a catch!
As the closure captures a reference to the instance of the class,
the latter would not be freed from memory until the former is.
But the closure is reference type as well, and the class instance would also hold a reference to it.
This phenomenon is called a *strong reference cycle* and will be discussed later.

## Property Observers

It is possible to add property observers on any (non-lazy) stored property.
They are called every time a property's value is set,
even if the new value is the same as the current one.
There are two kind of observation events:

* `willSet`, which is triggered *before* a value is stored; and
* `didSet`, which is triggered *after* a value is stored.

A property observer can observe one or both of those events:

```swift
enum StatusCondition {
  case burned, frozen, poisoned
}

struct Pokemon {
  /* ... */

  var statusCondition: StatusCondition? {
    willSet {
      if let newCondition = newValue {
        print("the pokemon is about to be \(newCondition)")
      }
    }

    didSet {
      var message = ""

      if let oldCondition = oldValue {
        message += "the pokemon was \(oldCondition) and "
      }

      if let newCondition = self.statusCondition {
        message += "the pokemon is now \(newCondition)"
      }

      print(message)
    }
  }
}

var bulby = Pokemon(
  species: (001, "Bulbasaur"),
  level: 1,
  stepsWalkedWithTrainer: 600,
  pokedexEntry: nil,
  statusCondition: nil)

bulby.statusCondition = .burned
// Prints "the pokemon is about to be burned"
// Prints "the pokemon is now burned"
print(bulby.statusCondition!)
// Prints "burned"
```

Notice that, like to the property getter we've seen earlier,
the `willSet` observer automatically receives an argument `newValue`.
Similarly, the `didSet` observer receives an argument `oldValue`,
which contains the previous value, before the property was set.
The freshly stored value can be accessed as usual with the dot syntax.

When the `statusCondition` property is set in the above example,
the first observer `willSet` is called.
Notice that it receives an argument ``

> Note that property observers are **not** called during initialization,
> as otherwise an observer may unsafely try to access the property it observers
> before it is initialized.

Note that it is also possible to define property observers on local or global variables:

```swift
var bulby = Pokemon(/* ... */) {
  didSet {
    print("Bulby has changed ...")
  }
}

bulby.level += 1
// Prints "Bulby has changed ..."
```

> ❔
>
> Will the observer be called if `Pokemon` is a class?

## Type Properties

All the properties we've seen above have beed defined for the instances of a type,
meaning that each instance of the type gets its own property values.
Swift also allows to define properties on the type itself.
There will be only one copy of that properties, no matter how many instances get created.
Such kind of properties is often termed [*static variables*](https://en.wikipedia.org/wiki/Static_variable) in other languages, such as C/C++ or Java.

Type properties are declared with the keyword `static`:

```swift
struct Pokemon {
  /* ... */

  static var strongest: Pokemon? = nil

  var level: Int {
    didSet {
      guard let strongest = Pokemon.strongest else {
        Pokemon.strongest = self
        return
      }

      if strongest.level < self.level {
        Pokemon.strongest = self
      }
    }
  }
}

var bulby = Pokemon(/* ... */)
bulby.level = 12

print(Pokemon.strongest!)
// Prints: Pokemon(species: (1, "Bulbasaur"), level: 12, ...)
```

> ❔
>
> Why `Pokemon.strongest` is equal to `nil` if we don't change the `bulby.level` property?

Note that all type properties **must** have a value.
Unlike type instances, types are initialized when the program starts.
As a result, they require all their properties to be properly initialized.

It is also possible to define computed type properties, as well as observers:

```swift
struct SomeStruct {
  static var computedProperty: Int {
    return 0
  }

  static var observedProperty: Int = 10 {
    didSet {
      print("SomeStruct.observedProperty has changed")
    }
  }
}
```

While enumeration instances can't get stored properties,
enumeration types are treated the same way as struct or class types:

```swift
enum SomeEnum {
  case someCase

  static var someStoredProperty: Int = 0
}
```

## Methods

A method is a function that is associated with a particular instance of a type.
They can be seen as a function (like the ones we've seen in Chapter 3)
that always captures (by value or reference) the instance it is associated with,
and assigns it to a special variable `self`.
Methods have the exact same syntax as functions:

```swift
struct Trainer {
  let name: String
  var friends: [Trainer]

  func isFriends(with anotherTrainer: Trainer) -> Bool {
    return self.friends.contains(where: { $0.name == anotherTrainer.name })
  }
}

var ash = Trainer(name: "Ash", friends: [])
var brock = Trainer(name: "Brock", friends: [])

ash.friends.append(brock)
print(ash.isFriends(with: brock))
// Prints "true"
```

> It is not mandatory to prepend a type's own property with `self` inside a method.
> Hence, we could have written only `firends.contains(...)` in the body of `isFriend(with:)`,
> since `friends` is a property of `Trainer`.
> However, we strongly discourage this practice, because it can lead to ambiguity.

Friendship is *usually* a commutative relation.
In the above example however, setting that Brock is a friend of Ash doesn't make Ash a friend of Brock.
Doing that with a struct can prove challenging.
Remembering that structs are value types,
a struct's method (or property getter, setter or observer) isn't allowed to mutate the struct.
That's because if an instance is declared as a constant,
calling this method would lead to a contradiction:

```swift
struct Trainer {
    /* ... */

    func makeFriends(with anotherTrainer: Trainer) {
        self.friends.append(anotherTrainer)
        // Error: Cannot use mutating member on immutable value: 'self' is immutable
        anotherTrainer.friends.append(self)
        // Error: Cannot use mutating member on immutable value: 'anotherTrainer' is a 'let' constant
    }
}
```

In the above example, the compiler error states exactly what we've been discussing.
In order to mark `self` as mutable, the keyword `mutating` should prefix the method declaration.
The second error is more familiar, as we've encountered it in Chapter 3.
It states that since `anotherTrainer` is a constant,
it is not allowed to change one of its property.
As a result, it should be marked as an `inout` parameter:

```swift
struct Trainer {
    /* ... */

    mutating func makeFriends(with anotherTrainer: inout Trainer) {
        self.friends.append(anotherTrainer)
        anotherTrainer.friends.append(self)
    }
}
```

Because classes are reference types,
their methods never have to be marked `mutating`.
Even if the reference is a constant,
the variables of the references instance can be mutated.

```swift
class Trainer {
  /* ... */

  func makeFriends(with anotherTrainer: Trainer) {
      self.friends.append(anotherTrainer)
      anotherTrainer.friends.append(self)
  }
}
```

Behind the scenes, a mutating method is actually a method that returns the instance's type.
When called, Swift assign the variable to which the instance is assigned to the result of the method.
This allows for an arguably clearer programming style,
while preserving the value semantics.
Incidentally, it is possible to assign `self` to a complete new instance in a mutating struct method:

```swift
struct Pokemon {
    let species: Species
    var level: Int

    mutating func evolve() {
        self = Pokemon(species: (002, "Ivysaur"), level: self.level)
    }
}

var bulby = Pokemon(species: (001, "Bulbasaur"), level: 16)
bulby.evolve()
print(bulby)
// Prints "Pokemon(species: (2, "Ivysaur"), level: 16)"
```

Had `evolve()` been a non-mutating method that returns a new instance of `Pokemon`,
the above code would be equivalent to:

```swift
struct Pokemon {
    let species: Species
    var level: Int

    func evolve() -> Pokemon {
        return Pokemon(species: (002, "Ivysaur"), level: self.level)
    }
}

var bulby = Pokemon(species: (001, "Bulbasaur"), level: 16)
bulby = bulby.evolve()
print(bulby)
// Prints "Pokemon(species: (2, "Ivysaur"), level: 16)"
```

Enumeration can also declare methods:

```swift
indirect enum SpeciesType {
  case grass, fire, water
  case dual(primary: SpeciesType, secondary: SpeciesType)

  func combine(with anotherType: SpeciesType) -> SpeciesType {
    return .dual(primary: self, secondary: anotherType)
  }
}

var lotadType = SpeciesType.water.combine(with: .grass)
```

Like functions, methods can be defined with default arguments and/or be overloaded:

```swift
struct Pokemon {
  let species: Species
  var level: Int

  mutating func levelUp(by levels: Int = 1) {
    self.level += levels
  }
}
```

Finally, similarly as type properties,
Swift allows to define type methods on structs, classes and enumerations.
They are defined with the keyword `static`:

```swift
struct Pokemon {
  /* ... */

  static func createFromSpecies(_ species: Species) -> Pokemon {
    return Pokemon(species: species, level: 1)
  }
}

let bulby = Pokemon.createFromSpecies((001, "Bulbasaur"))
```

## Subscripts

We've already used subscripts with arrays and dictionaries,
to get an indexed value:

```swift
let letters = ["A", "s", "h"]
print(letters[1])
// Prints "h"
```

Custom subscripts can be defined on structs, classes and enumerations.
For instance, here is a (rather poor) alternative implementation of a dictionary of `Int: String`:

```swift
struct InefficientDictionary {
    var storage: [(Int, String)]

    subscript(key: Int) -> String? {
        get {
            if let (_, value) = self.storage.first(where: { k, _ in k == key}) {
                return value
            }
            return nil
        }

        set {
            if let index = self.storage.index(where: { k, _ in k == key }) {
                if let value = newValue {
                    self.storage[index].1 = value
                } else {
                    self.storage.remove(at: index)
                }
            } else {
                if let value = newValue {
                    self.storage.append((key, value))
                }
            }
        }
    }
}

var pokedex = InefficientDictionary(storage: [])
pokedex[001] = "Bulbasaur"
print(pokedex[001]!)
// Prints "Bulbasaur"
```

Similarly to computed properties,
the `get` keyword can be dropped if the subscript should only be used to read a value.

Most of the time, subscripts accept only one argument.
But several can be defined as well.
For instance, it is a common practice to represent a matrix n × m as a 1-dimensional array:

```swift
struct Matrix {
  var grid: [Int]

  subscript(row: Int, column: Int) -> Int {
    return self.grid[row * column + column]
  }
}

let matrix = Matrix(grid: [0, 1, 2, 3])
print(matrix[1, 1])
// Prints "3"
```

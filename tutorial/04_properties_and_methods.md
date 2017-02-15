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

## Instance Methods

```swift
indirect enum SpeciesType {
  case grass, fire, water
  case dual(primary: SpeciesType, secondary: SpeciesType)

  func hasType(_ speciesType: SpeciesType) -> Bool {

  }
}
```

## Type methods

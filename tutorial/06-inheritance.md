---
layout: page
title: Inheritance
permalink: /tutorial/chapter-6/
---

<span class="prev">
  <a href="{{ site.baseurl }}tutorial" title="Tutorial Index">
    <span class="arrow">←</span> Index
  </a>
</span>
<hr />

Swift supports [class inheritance](https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)),
a mechanism that allows a class to share parts of its implementation with subclasses,
so as to factor the common parts of those subclasses.
It is at the core of object-oriented programming.

> Disclaimer for the Java lovers: Swift is **not** an object-oriented language.
> Although it supports that feature, it is often recommended against using it.
> We'll see later how protocols address (arguably much better) the same problem as object-orientation.

## Subclassing

A class can subclass a class to inherits its properties and methods.
The former is then called the *subclass*, while the later is called the *base class*.
A subclass refers to its base class with the keyword `super`.
Subclassing is declared with the following syntax:

```swift
struct Pokemon { /* ... */ }

class PokemonLover {
  var name: String
  var friends: [PokemonLover] = []

  init(name: String) {
    self.name = name
  }

  convenience init(name: String, bestFriend: PokemonLover) {
    self.init(name: name)
    self.friends = [bestFriend]
    bestFriend.friends.append(self)
  }

  func makeFriends(with another: PokemonLover) {
    self.friends.append(another)
    another.friends.append(self)
  }
}

class Trainer: PokemonLover {
  var pokemons: [Pokemon]

  init(name: String, pokemons: [Pokemon]) {
    self.pokemons = pokemons
    super.init()
  }
}
```

In the above example, `Trainer` is a subclass of `PokemonLover`,
meaning that it inherits from the `name` property of `PokemonLover`,
as well as its `makeFriends(with:)` method.
It also defines a new property `pokemons`,
which will be stored only in instances of `Trainer` and not that of `PokemonLover`.

Initializer on the other hand are **not** inherited,
unless the subclass doesn't add any stored property,
and doesn't define any designated initializer.
It makes sense, remembering that the job of an initializer is to provide a value to all its properties before it transfers control.
The order in which properties and inherited properties is also clearly defined.
A subclass must first initialize all its properties before it lets its subclass initialize its own.
In the above example, this can be observed as `Trainer.init(name:location:)` first initializes `self.pokemons`
before it calls `super.init(name:)`.
Doing that in the other way around would trigger a compiler error.

A base class may have several subclasses,
but a subclass can have only one base class,
as Swift doesn't support [multiple inheritance](https://en.wikipedia.org/wiki/Multiple_inheritance).
Of course, subclasses can themselves be subclassed,
and the same rules apply:

```swift
indirect enum SpeciesType { /* ... */ }

class PokemonLover {}
class Trainer: PokemonLover { /* ... */ }

class GymLeader: Trainer {
  let location: String

  init(name: String, location: String, pokemons: [Pokemon]) {
    self.location = location
    super.init(name: name, pokemons: pokemons)
  }
}

class EliteFourMember: Trainer {
  let specialty: SpeciesType

  init(name: String, specialty: SpeciesType, pokemons: [Pokemon]) {
    self.specialty = specialty
    super.init(name: name, pokemons: pokemons)
  }
}
```

In the above example, `PokemonLover` is subclassed by `Trainer`,
which in turn is subclassed by `GymLeader` and `EliteFourMember`.

## Polymorphism and Casting

[Subtype polymorphism](https://en.wikipedia.org/wiki/Polymorphism_(computer_science))
corresponds to the idea that a subclass can act as one of its base class.
For instance, in our earlier example,
the signature of the method `makeFriends(with:)` is `(PokemonLover) -> ()`.
However, it is possible to pass it an instance of `GymLeader`:

```swift
let oak = PokemonLover(name: "Professor Oak")
let brock = GymLeader(
  name: "Brock",
  location: "Pewter City",
  pokemons: [
    Pokemon(species: (074, "Geodude"), level: 12),
    Pokemon(species: (095, "Geodude"), level: 14)
  ])

oak.makeFriends(with: brock)
print(oak.friends)
// Prints "[GymLeader]"
```

In this example, `brock` is typed `GymLeader` but it remains compatible with `PokemonLover`,
as its type is a derived class (i.e. a sublcass or a derived class of a subclass) of the latter.

It is also possible to initialize a variable with an instance of a derived class:

```swift
let brock: PokemonLover = GymLeader(name: "Brock", location: "Pewter City")
```

Now, `brock` is typed `PokemonLover` but actually refers to an instance of `GymLeader`.
This is the one the the main reason why classes are reference types;
`brock` is a **reference** to an object that can act as an instance of `PokemonLover`.
However, now that `brock` is typed `PokemonLover`,
we can't access the properties of `GymTrainer`:

```swift
print(brock.location)
// Error: Value of type 'PokemonLover' has no member 'location'
```

Actually, the error message tells the whole story.
Indeed, the compiler is unaware that `brock` actually refers to an instance `GymLeader`.
This can be indicated by the use of *casting*:

```swift
print((brock as! GymLeader).location)
// Prints: "Pewter City"
```

Swift has two casting operators:

* `value as? Type` tries to cast `value` as `Type` and returns `Type?`,
  with `value` casted as `Type` if the casting succeeded, or `nil` if it failed.
* `value as! Type` either returns `value` caster as `Type`,
  or triggers a runtime error if the casting failed.

This is very similar to optional unwrapping (discussed in Chapter 1):
the `as!` operator corresponds to a force-unwrapping
and shouldn't be used unless some prior logic makes sure the casting will succeed.

A subclass may be casted as any of its base class, but a base class may not:

```swift
print((oak as! GymLeader).location)
// Error: Could not cast value of type 'Trainer' to `GymLeader`
```

The operator `is` allows to check if a referenced value is of a given type:

```swift
if brock is GymLeader {
  print("\(brock.name) is a gym leader")
}
// Prints "Brock is a gym leader"
```

Note that `is` doesn't check for the *exact* type of the given value.
It only checks if it can act as the given type:

```swift
if brock is Trainer {
  print("\(brock.name) is a Pokemon trainer")
}
// Prints "Brock is a Pokemon trainer"
```

A `switch` statement can also check for the type of a referenced value:

```swift

switch brock {
case is GymLeader:
  print("\(brock.name) is a gym leader")
case is EliteFourMember:
  print("\(brock.name) is an Elite Four member")
case is Trainer:
  print("\(brock.name) is a Pokemon trainer")
default:
  print("\(brock.name) is a Pokemon Lover")
}
// Prints "Brock is a gym leader"
```

> ❔
>
> What would be the printed text if we had put `case is Trainer: ...` first?

## Properties and Methods Overriding

A subclass may override properties and/or methods of its base class.
Overridden elements are declared with the keyword `override`:

```swift
class EliteFourMember: Trainer {
  /* ... */

  override func makeFriends(with another: PokemonLover) {
    guard another is EliteFourMember else {
      print("Elite Four members make friends with other Elite Four members only")
      return
    }
    super.makeFriends(with: another)
  }
}

let malva = EliteFourMember(
  name: "Malva",
  specialty: .fire,
  pokemons: [
    Pokemon(species: (668, "Pyroar"), level: 63)
  ])

malva.makeFriends(with: brock)
// Prints "Elite Four members make friends with other Elite Four members only"
```

The method `makeFriends(with:)` is overridden for all instances of `EliteFourMember`.
Notice that using the keyword `super` to refer the base class in methods isn't limited to initializers.
In the above example, it is used to delegate to the base class' implementation.

Even if a reference is typed with a superclass (i.e. the base class or one of its superclasses) class,
the overridden method (or property) is always used,
rather than that of the ancestor class:

```swift
let malva: PokemonLover = EliteFourMember(/* ... */)
malva.makeFriends(with: brock)
// Prints "Elite Four members make friends with other Elite Four members only"
```

Inherited properties can be overridden with a custom getter (and setter, if appropriate),
or a property observer.
Note that the potential observers defined from the base class will still apply.
Subclasses cannot know if the properties they inherit are stored or computed;
they only know their types and names:

```swift
class EliteFourMember: Trainer {
  /* ... */

  override var name: String {
    get {
      return "Elite Four \(super.name)"
    }

    set {
      if newValue.hasPrefix("Elite Four ") {
        super.name = String(newValue.characters.dropFirst(11))
      } else {
        super.name = newValue
      }
    }
  }
}

print(malva.name)
// Prints: Elite Four Malva
```

In the above example, the `name` property is overridden for all instances of `EliteFourMember`,
so that the prefix "Elite Four " is always added when accessing the value.

A class may disallow its subclasses to override certain methods or properties,
by marking them `final`:

```swift
class PokemonLover {
  /* ... */

  final var friends: [PokemonLover] = []
}

class Trainer: PokemonLover {
  /* ... */

  override var friends: [PokemonLover] {
  // Error: Var overrides a 'final' var
    didSet {
      print("the trainer friends changed")
    }
  }
}
```

Besides, an entire class may be marked as `final`, as to deny any class to subclass it.

## Initializers Overriding

A subclass may override the designated initializers (and only them) of its base class.

```swift
class Trainer {
  /* ... */

  override init(name: String) {
    print("new challenger approaching")
    self.pokemons = []
    super.init(name: name)
  }
}

let ash = Trainer(name: "Ash")
// Prints "new challenger approaching"
```

If a subclass overrides **all** its base class designated initializers
(or doesn't define any, hence inheriting from them as stated earlier),
it inherits all the convenience initializers of its base class:

```swift
let ash = Trainer(name: "Ash", bestFriend: brock as! Trainer)
```

Because `init(name:)` has been overridden,
and because it is the only designated initializer of `PokemonLover`,
the `Trainer` type inherited the `init(name:bestFriend:)` convenience initializer of `PokemonLover`.

A class may specify that one or several of its initializer have to be overridden by its subclasses.
This is declared with the keyword `required`.
Subclasses should also prefix their overridden implementation with `required`:

```swift
class Trainer {
  /* ... */

  required init(name: String, pokemons: [Pokemon]) {
    self.pokemons = pokemons
    super.init(name: name)
  }
}

class GymLeader: Trainer {
  /* ... */

  let location: String = "unknown"

  required init(name: String, pokemons: [Pokemon]) {
    super.init(name: name, pokemons: pokemons)
  }
}

class EliteFourMember: Trainer {
  /* ... */

  let specialty: SpeciesType? = nil

  required init(name: String, pokemons: [Pokemon]) {
    super.init(name: name, pokemons: pokemons)
  }
}
```

> Notice the addition of a default value for the stored properties of `GymLeader` and `EliteFourMember`,
> allowing us to directly call `super.init(name:pokemons:)` in the their respective override of the required initializer.

<nav id="post-nav">
  <span class="prev">
    <a href="{{ site.baseurl }}tutorial/chapter-5" title="Chapter 5">
      <span class="arrow">←</span> Initializers
    </a>
  </span>
  <span class="next">
      <a href="{{ site.baseurl }}tutorial/chapter-7" title="Chapter 7">
          Protocols, Extensions and Generics <span class="arrow">→</span>
      </a>
  </span>
</nav>

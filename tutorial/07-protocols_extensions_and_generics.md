---
layout: page
title: Protocols, Extensions and Generics
permalink: /tutorial/chapter-7/
---

<span class="prev">
  <a href="{{ site.baseurl }}tutorial" title="Tutorial Index">
    <span class="arrow">←</span> Index
  </a>
</span>
<hr />

Protocols represent a set of requirements that a type accepts to conform to.
Although some major differences can be observed,
they can be assimilated to what other languages (like Java) call interfaces.

## Protocol Requirements

A protocol is declared with the keyword `protocol`:

```swift
protocol Technique {
  // The protocol definition goes here.
}
```

Custom types can then be declared to *conform* to one or more protocols (i.e. implement their set of requirements).
Structs, classes and enumerations can conform to a protocol:

```swift
[struct|class|enum] Ember: Technique, AnotherProtocol {
  // The [struct|class|enum] definition goes here.
}
```

If the custom type is a subclass, its base class should be declared first:

```swift
class Trainer: PokemonLover, AnotherProtocol {
  // The class definition goes here.
}
```

A protocol can be declared conforming to one or more protocols as well:

```swift
protocol Technique: AnotherProtocol {
  // The protocol definition goes here.
}
```

It is possible to declare that the conforming type of a protocol must be class,
by adding the keyword `class` to the list of protocol conformances:

```swift
protocol ReferenceTypeTechnique: class {
  // The protocol definition goes here.
}
```

A protocol can require its conforming types to implement a particular property,
with a particular name type.
It can also precise if that property should be *at least* read-only or settable as well.

```swift
protocol Technique {
  var name: String { get }
  var usedPowerPoints: Int { get set }
}

struct Ember: Technique {
  let name: String
  var usedPowerPoints: Int
}
```

Note that the property `usedPowerPoints` has to be declared a variable in `Ember`,
because the protocol `Technique` states it should be settable.
The property `name` on the other hand may be declared as a variable rather than a constant,
because the protocol only states that is should be *at least* read-only.

Property conformance can also be achieved with computed properties,
or with stored property observers:

```swift
enum Language {
  case english, french, german, japanese
}

let displayLanguage = Language.japanese

struct Ember: Technique {
  var name: Int {
    switch displayLanguage {
    case .japanese:
      return "ひのこ"
    case .french:
      return "Flammèche"
    default:
      return "Ember"
    }
  }

  var usedPowerPoints: Int {
    didSet {
      if self.usedPowerPoints < oldValue {
        print("\(oldValue - self.usedPowerPoints) power point(s) was(were) just used")
      }
    }
  }
}
```

Properties can also be required to be implemented at the type level (i.e. statically):

```swift
protocol Technique {
  /* ... */

  static var maxPowerPoints: Int { get }
}

struct Ember: Technique {
  /* ... */

  static let maxPowerPoints: Int =　25
}
```

> Note that the type property `maxPowerPoints` is defined for the `Ember` type only.
> Any other protocol that conforms to `Technique` will have to define its own `maxPowerPoints` property,
> and it will be unrelated from that of `Ember`.

A protocol can require its conforming types to implement a particular method,
with a particular name and signature:

```swift
typealias Species = (number: Int, name: String)

struct Pokemon {
    let species: Species
    var level: Int
    var lostHealthPoints: Int
}

protocol Technique {
  /* ... */

  func perform(on defender: Pokemon) -> Pokemon
}

struct Ember {
  /* ... */

  func perform(on defender: Pokemon) -> Pokemon {
    return Pokemon(
      species: defender.species,
      level: defender.level,
      lostHealthPoints: defender.lostHealthPoints + 12)
  }
}
```

If a method should be able to mutate its type, a protocol can mark it `mutating`.
If it does, the mutable can be mutable or not.
If it doesn't, the method **can't** be mutating:

```swift
protocol Technique {
  /* ... */

  mutating func perform(on defender: Pokemon) -> Pokemon
}

struct Ember {
  /* ... */

  mutating func perform(on defender: Pokemon) -> Pokemon {
    self.usedPowerPoints += 1
    return Pokemon(
      species: defender.species,
      level: defender.level,
      lostHealthPoints: defender.lostHealthPoints + 12)
  }
}
```

> note that the `mutating` keyword should not be prefixed in conforming classes.

Finally, a protocol can require its conforming types to implement a particular initializer:

```swift
protocol Technique {
  /* ... */

  init(usedPowerPoints: Int)
}

struct Ember {
  /* ... */

  init(usedPowerPoints: Int = 0) {
    self.usedPowerPoints = usedPowerPoints
  }
}
```

> Note that protocols don't allow to define default arguments in intializer (or method) requirements.
> The conforming types however are free to do so.

If `Ember` was a class, it would treat the initializer requirement the same way
as a required initializer it would have get from a base class.
Hence, the keyword `required` must suffix the initializer declaration:

```swift
class Ember {
  /* ... */

  required init(usedPowerPoints: Int = 0) {
    self.usedPowerPoints = usedPowerPoints
  }
}
```

## Protocols as Types

Even if protocols don't represent actual objects (or instances of),
they can be used as a type in your code.
The idea is similar as the use of a base class to denote any instance of its derived classes,
as we've seen in Chapter 6:
a protocol designates anything that can act as it's specified:

```swift
struct Ember: Technique { /* ... */
struct Surf: Technique { /* ... */}

let techniques: [Technique] = [Ember(), Surf()]
print(techniques)
// Prints "[Ember(usedPowerPoints: 0), Surf(name: "Surf", usedPowerPoints: 0)]"
```

> Note that we are forced to explicit type the `techniques` array,
> because Swift's type inference doesn't search for matching protocols,
> only for concrete types.
> In fact, doing so could lead to ambiguities for types that would conform to multiple protocols.
> For instance, what should be the type of `array` in the following example?
>
> ```swift
> protocol P1 {}
> protocol P2 {}
>
> struct S1: P1, P2 {}
> struct S2: P1, P2 {}
>
> let array = [S1(), S2()]
> ```

## Self Requirements

One of the features that distinguish a protocol the most from what is generally understood as interfaces
is their ability to refer to the type that conforms to it.
This is called a *self requirement*:

```swift
protocol Technique {
  /* ... */

  static func == (lhs: Self, rhs: Self) -> Bool
}

struct Ember: Technique {
  /* ... */

  static func == (lhs: Ember, rhs: Ember) -> Bool {
    return lhs.usedPowerPoints == rhs.usedPowerPoints
  }
}
```

In the protocol definition,
`Self` acts as a placeholder for the type that will conform to its requirements.
As a result, the implementation of the `==` operator in `Ember` is typed `(Ember, Ember) -> Bool`,
and not `(Technique, Technique) -> Bool`.
Self requirements enable a finer grained specification of the protocol.

Actually, Swift already has an `Equatable` built-in protocol that acts exactly as the self requirement in the above example.
All built-in types that are equatable respect this protocol,
which allows to write things like `8 == 8`.
Remembering that protocols can be declared conforming to other protocols,
The above example could be rewritten as the following:

```swift
// already defined in Swift:
// protocol Equatable {
//   static func == (lhs: Self, rhs: Self) -> Bool
// }

protocol Technique: Equatable { /* ... */ }
struct Ember: Technique { /* ... */ }
```

Note that after adding a Self requirement to the `Technique` protocol,
it is no longer possible to create an array of type `[Technique]`:

```swift
let techniques: [Technique] = [Ember(), Surf()]
// Error: Protocol 'Technique' can only be used as a generic constraint because it has Self or associated type requirements
```

It has been said in Chapter 1 that an "array is a collection of values of **homogeneous** type".
However, because of the self requirements,
the `Technique` protocol doesn't denote homogeneous types anymore,
as its static method requirement `==` isn't defined between different conforming types:

```swift
Ember() == Surf()
// Error: Type of expression is ambiguous without more context
```

> Although a bit unclear, this error indicates that the compiler cannot find a way to apply `==`
> between an instance of `Ember` and an instance of `Surf`.

## Associated Types

A protocol can also declares placeholders for the types it should be associated with.
This is useful when the conforming type should have some kind of relationship with another type:

```swift
protocol Stack {
  associatedtype Element

  var head: Element? { get }

  init(_ initialValue: [Element])

  func pushing(_ element: Element) -> Self
  func popped() -> Self
}

struct ArrayBackedStack: Stack {
  typealias Element = Int

  var storage: [Element]

  var head: Element? {
    return self.storage.last
  }

  init(_ initialValue: [Element] = []) {
    self.storage = initialValue
  }

  func pushing(_ element: Element) -> ArrayBackedStack {
    return ArrayBackedStack(self.storage + [element])
  }

  func popped() -> ArrayBackedStack {
    return ArrayBackedStack(Array(self.storage.dropLast()))
  }
}

var stack = ArrayBackedStack([8, 3])
print(stack.popped().head!)
// Prints "8"
```

The `Stack` protocol defines an associated type `Element`,
which acts as a placeholder for the properties and methods requirements.
Conforming types can then specify which other type they'd like to use as the association.
In the above example, `ArrayBackedStack` chooses `Int` as its associated type,
by declaring a type alias.

This mechanism allows a certain degree of genericity.
A protocol can design the requirements for an unlimited number of conforming types that would have the same form.
Note also that as many associated types as needed can be declared.
Later in this chapter, we'll see how we can go even further into that direction.

## Extensions

Extensions allows to add functionalities (or conforming protocols) to existing types.
As they are declared *outside* a type declaration,
they don't require to know anything more than the public interface of the type they extend.
Extensions can:

* add computed instance and type properties;
* add instance and type methods;
* provide new initializers; and
* make existing types conform to a protocol.

Extensions are declared with the keyword `extension`,
followed by the name of the type they extend:

```swift
typealias Species = (number: Int, name: String)

struct Pokemon { /* ... */ }

extension Pokemon {
  var description: String {
    return "a \(self.species.name) at level \(self.level)"
  }
}

let sparky = Pokemon(species: (135, "Jolteon"), level: 31)
print(sparky.description)
// Prints "a Jolteon at level 31"
```

> Note that extensions **can't** add stored instance properties,
> or add property observers to existing properties.
> Doing that would change the size of the extended type's instances,
> which would introduce a host of issues regarding initialization,
> serialization or usability in general.
> If that feature is absolutely required, subclassing is the way to go.
>
> Static properties are not concerned by this limitation,
> as they do not change the size of the type's instances.
> They are stored ad-hoc fashion.

Extensions can also be defined on a protocol.
Doing so extends all types that conform to the protocol:

```swift
extension Technique {
  var remainingPowerPoints: Int {
    return Self.maxPowerPoints - self.usedPowerPoints
  }
}

let ember = Ember(usedPowerPoints: 7)
print(ember.remainingPowerPoints)
// Print "18"
```

> Note that `Self` (with a capital letter) corresponds to the type of `self`.
> In other words, `Self = type(of: self)`.

Protocol extensions can be used to give a default implementation to a protocol method requirement:

```swift
extension Technique {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.usedPowerPoints == rhs.usedPowerPoints
  }
}

struct Ember: Technique {
  /* ... */

  // Use the default implementation defined in the extension if not defined.
  // static func == (lhs: Ember, rhs: Ember) -> Bool {
  //   return lhs.usedPowerPoints == rhs.usedPowerPoints
  // }
}
```

Extensions only need to access the public interface of the type they extend.
As a result, they can be defined on types that otherwise couldn't be modified:

```swift
extension Int {
    subscript(digit n: Int) -> Int {
        if n == 0 {
            return self % 10
        }
        return (self / 10)[digit: n - 1]
    }
}

6485[digit: 1]
// Prints "8"
```

## Protocols and Generics

We've already seen generic functions in action, in Chapter 3.
Swift also allows to declare generic types,
for which generic parameters apply to the whole type.
Remembering our example of stack that illustrated associated types, earlier in this chapter,
here is another way to implement a generic stack.

```swift
struct ArrayBackedStack<T> {
  var storage: [T]

  var head: T? {
    return self.storage.last
  }

  init(_ initialValue: [T] = []) {
    self.storage = initialValue
  }

  func pushing(_ element: T) -> ArrayBackedStack {
    return ArrayBackedStack(self.storage + [element])
  }

  func popped() -> ArrayBackedStack {
    return ArrayBackedStack(Array(self.storage.dropLast()))
  }
}

var stack = ArrayBackedStack([8, 3])
print(stack.popped().head!)
// Prints "8"
```

In the first example, initializing a stack with `Double` elements would have required to define a new kind of stack,
whose associated type would have been set to `Double`.
Now, it suffices to specialize `ArrayBackedStack` for any other type:

```swift
var stackOfDouble = ArrayBackedStack([8.3, 3.8])
print(stackOfDouble.popped().head!)
// Prints "8.3"
```

But we lost protocol conformance.
In the other previous case, `ArrayBackedStack` was conforming to `Stack`.
While this had the advantage of better describing the role of the type,
it also meant that `ArrayBackedStack` would have benefitted from all extensions that could be made to `Stack`.
Thankfully, Swift allows for generic types to work with protocols as well:

```swift
struct ArrayBackedStack<T>: Stack { /* ... */ }

extension Stack {
  var elements: [Element] {
    if self.head == nil {
      return []
    }
    return [self.head!] + self.popped().elements
  }
}

print(ArrayBackedStack(["chu!", "Pika"]).elements.joined())
// Prints "Pikachu!"
```

Once again, `ArrayBackedStack` conforms to `Stack`, and hence benefits from its extensions.
With the help of function signatures,
the compiler was even able to infer that the associated type `Element` had to be mapped onto its the parameter `T`.
Hence, it wasn't required to add `typealias Element = T` in the type definition.

In all above examples, the compiler also inferred the type of the stacks,
because of the type of the array they was given as argument.
However, it is possible (and sometimes necessary) to declare explicitly how a generic type should be specialized:

```swift
let stackOfInts: ArrayBackedStack<Int>
```

It is possible to add type constraints on the generic parameters
(note that this is also true for generic function):

```swift
struct ArrayBackedStack<T: Equatable> { /* ... */ }

let stackOfInts: ArrayBackedStack<Int>
let stackOfSpeciesTypes: ArrayBackedStack<SpeciesType>
// Error: Type 'SpeciesType' does not conform to protocol 'Equatable'
```

Type constraints can even be much more complex.
For instance, the following function accept any pair of type conforming to `Stack`,
as long as are containers for the same elements,
and that the type of these elements is equatable:

```swift
func == <S1: Stack, S2: Stack>(lhs: S1, rhs: S2) -> Bool
    where S1.Element == S2.Element, S1.Element: Equatable {
  guard let leftHead = lhs.head else {
    return rhs.head == nil
  }
  guard let rightHead = rhs.head, leftHead == rightHead else {
    return false
  }
  return lhs.popped() == rhs.popped()
}

print(ArrayBackedStack([1, 2]) == ArrayBackedStack([1, 2]))
// Prints "true"
```

<nav id="post-nav">
  <span class="prev">
    <a href="{{ site.baseurl }}tutorial/chapter-6" title="Chapter 6">
      <span class="arrow">←</span> Inheritance
    </a>
  </span>
</nav>

# Constants, Variables and Types

Swift is statically **strongly** typed.
It means that at compile time, Swift ensures that each variable (or constant) is unambiguously associated with a single type, and that each opration on that variable (or constant) is well defined for that type.

## Constants and Variables

Variables are declared with the keyword `var`:

```swift
var someVariable = 54

someVariable = 42

someVariable = "10"
// Error: Cannot assign value of type "String" to type "Int"
```

Constants are declared with the keyword `let`.
Unlike variables, it is not possible to assign a value to a constant after it has been initialized:

```swift
let someConstant = 54

someConstant = 42
// Error: Immutable value 'someConstant' may only be initialized once
```

The value of variable and constants can be printed with the built-in function `print(_:)`:

```swift
var someVariable = 42
print(someVariable)
// Prints 42
```

Values can be included in strings by wrapping them in parentheses, and adding a backslash (`\`) before the first one:

```swift
print("The variable is equal to \(someVariable).")
// Prints "The variable is equal to 42."
```

## Type Inference

Swift comes with a powerful type inference engine that avoid the need to constantly type every variable of the program (like in Java for instance).
When one writes `let x = 42`, Swift evaluates that the expression at the right of the assignement (the *rvalue*) is of type `Int`.
As a result, it infers that the variable on the left (the *lvalue*) must by typed with `Int`.

It is however possible (and sometimes necessary) to explicitly specify the type of a variable or constant with what is called *type annotations*.
In the example below, the variable `someNumber` is explicitly typed with `Double` (a double precision floating point number), which tells Swift that it should consider it an `Int` value.

```swift
let someNumber: Double = 42
```

It is possible to declare multiple variables of the same type on a single line.
Note that this should be done sparingly and **only when the variables are clearly related**:

```swift
let x, y: Int
```

The type of an expression can be retrieved with the built-in function `type(of:)`:

```swift
print(type(of: 42))
// Prints "Int"
print(type(of: "Hello"))
// Prints "String"
```

Types are first-class citizen, meaning that they can be assigned to variables (or constants), like any other value:

```swift
let someType = type(of: "Hello")
print(someType)
// Prints "String"
```

## Optionals

One interesting feature of Swift is its optional types.
An optional denotes a value that may be present or not.
Any type suffixed with the operator `?` is an optional type, in which the original type has been *wrapped*.

```swift
var x: Int?
print(x)
// Prints "nil"
```

In the above example, since no value is provided for `x`, Swift automatically assigns it to the special value `nil` that denotes the *absence* of a value.

Values can be assigned to optionals the same way they would have been assigned to the original type.
It is also possible to assign `nil` manually.

```swift
var x: Int? = 42
print(x)
// Prints "Optional(42)"
```

As Swift emphasis on safety, accessing the value of an optional is a bit different than for non-optionals.
If we simply assign the value of an optional type to another variable, that variable should also be an optional (otherwise the type checker will complain about it).
By suffixing an optional value with the operator `!`, Swift will return the wrapped value if it exists, or will throw an error at runtime if the optional value was `nil`,
This process is called *forced-unwrapping*:

```swift
var x: Int? = 42
let y = x
print(y)
// Prints "Optional(42)"

let z = x!
print(z)
// Prints "42"
```

> Note that the above program will be compiled with a warning about the implicit coercion from `Int?` to `Any`.
> You can safely ignore this warning for the time being.
> We'l how to circumvent it later.

> You should never force-unwrap an optional unless your algorithm makes sure it will be assigned to a value before you do it.
> We'll see a way to do that later.

Another less common way to define optionals is to suffix the wrapped type with the operator `!`.
Such optional is said to be *implicitly unwrapped*, and avoid the need to append the `!` to get the wrapped value.

```swift
var value: String

let possibleValue: String? = "An optional string."
value = possibleValue! // the ! is required

let assumedValue: String! = "An implicitly unwrapped optional string."
value = assumedValue // no need for !
```

## Exercise

Write a program that defines an optional `String` variable, assigns its value to a `String` constant and prints the value of the constant.

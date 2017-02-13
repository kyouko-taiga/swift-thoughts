# Functions and Closures

## Function Signatures

Functions are declared with the keyword `func`:

```swift
func min(lhs: Int, rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}
```

Like in mathematics, a function has a signature (i.e. a domain and a codomain).
In the above example, the signature of the function is `Int, Int -> Int`, meaning that it takes two `Int` parameters and returns one `Int` value.

When referring to the signature of Swift functions in comments and documentation, the convention is to use its name, followed by the list of parameters separated by `:`.
For instance, we would refer to the signature of the above function with `min(lhs:rhs:)`.
This convention is borrowed from Objective-C and can be observed through all official documentation.

> Note that this example just serves to illustrate the definition of functions.
> Swift already has a built-in `min(_:_:)` function which should always be preferred.

A function can be called by using its name, followed by the arguments to pass into its parameters:

```swift
print(min(lhs: 1, rhs: 2))
// Prints "1"
```

Notice that we had to label its arguments.
By default, functions use their parameter names as labels for their arguments.
It can prove very useful to distinguish between overloaded functions (see below), or when the parameters are not completely obvious.
For instance, the character collection of a `String` has a method `split(whereSeparator:)` whose result is quite obvious, thanks to its labeled parameter.

It is possible to specify custom labels for the function parameters.
Notice that however, the parameters keep their respective name *inside* the function body:

```swift
func min(between lhs: Int, and rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}

print(min(between: 1, and: 2))
// Prints "1"
```

Finally, when the name of the function is clear enough, it is possible to specify that the labels aren't required:

```swift
func min(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}

print(min(1, 2))
// Prints "1"
```

Functions can return multiple values by returning a tuple.
For instance, this function takes 3 parameters and returns the minimum and maximum values:

```swift
func minmax(_ first: Int, _ second: Int, _ third: Int) -> (minimum: Int, maximum: Int) {
    return (min(min(first, second), third), max(max(first, second), third))
}

print(minmax(1, 2, 3))
// Prints "(1, 3)"
```

Functions are first-class citizen, meaning that they can be assigned to variables (or constants) like any other value:

```swift
func min(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}

let f = min
print(f(1, 2))
// Prints "1"
```

> ❔
>
> What type did Swift infer for the constant `f`?

## `guard` statements

A `guard` statement is similar to an `if` statement, but should be preferred in situations when some condition should hold for the program flow to continue:

```swift
let studentMark: Double? = 4.7

guard let mark = studentMark else {
  print("the student didn't attend the exam")
  return
}
```

> Notice the use of the `return` keyword in the `else` clause of the guard.
> This is because `guard` should always transfer control if the condition doesn't hold.
> As such, it is usually used

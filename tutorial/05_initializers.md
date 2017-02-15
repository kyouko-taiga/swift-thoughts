It is possible to define a default values for stored properties:

```swift
struct Pokemon {
  let species: Species
  var level = 1
}
```

> Note that if we had specify a default value for the `species` property,
> it would no longer be possible to initialize `Pokemon` with a different value.
> That's because the initializer is actually called *after* all properties have received their default values.
> Since `species` is a constant, even the initializer can't change its value.

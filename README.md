# OneAxisGeometryReader

OneAxisGeometryReader is a Swift package that attempts to reproduce the behavior of the `GeometryReader` view, but on a single axis.

## The problem this package solves
Let's say you want to achieve a table like layout, you might be tempted to write something like this:
```swift
GeometryReader { geometry in
VStack {
    HStack(spacing: 0) {
        Text("Hello world!")
            .frame(width: geometry.size.width*0.5, alignment: .leading)
            .fixedSize()
        Text("Foo")
            .frame(width: geometry.size.width*0.25, alignment: .leading)
            .fixedSize()
        Text("Bar")
            .frame(width: geometry.size.width*0.25, alignment: .leading)
            .fixedSize()
    }
    HStack(spacing: 0) {
        Text("Hello SwiftUI!")
            .frame(width: geometry.size.width*0.5, alignment: .leading)
        .fixedSize()
        Text("Baz")
            .frame(width: geometry.size.width*0.25, alignment: .leading)
        .fixedSize()
        Text("XYZ")
            .frame(width: geometry.size.width*0.25, alignment: .leading)
        .fixedSize()
    }                
}
}.padding()
```

And except a result similar to this:
![Expectation : A red square with the same size as it's sibling text](https://raw.githubusercontent.com/adtrevor/OneAxisGeometryReader/master/readme_ressources/horizontalgeometryreader.png)

But the actual result is this one:
![Reality : An overly size rectangle, taking the whole screen, next to the text](https://raw.githubusercontent.com/adtrevor/OneAxisGeometryReader/master/readme_ressources/geometryreader.png)

The SwiftUI API as it currently is seems to except `GeometryReader` to only be used in a place where its parent view size is constrained explicitly.
The reason why might not seem obious at first but it's definetely understandable when you think about what the layout system does. Many "container views" (`Group`, `HStack`, `VStack`...) define (at least partially) their size  in function of their children, but `GeometryReader` has its contents that define their size in function of their parent. When you nest a `GeometryReader` in an unconstrained container view, you end up in a case where the the *parent size* depends on the *child size*, and where the *child size* depends on the *parent size*, an hardly solvable equation!
SwiftUI still handles this as much gracefully as it can: if the container view hasn't any explicit fixed size, it will expand till it reaches a constraint in one of it's ancestor, this might be the size of the device screen, hence the result we got in our example.

## A solution
OneAxisGeometryReader attempts to solve this issue by only reading the geometry on a specific axis, enabling to break the cyclic size dependency on the other axis it doesn't read:
```swift
HGeometryReader { width in
VStack {
    HStack(spacing: 0) {
        Text("Hello world!")
            .frame(width: width*0.5, alignment: .leading)
            .fixedSize()
        Text("Foo")
            .frame(width: width*0.25, alignment: .leading)
            .fixedSize()
        Text("Bar")
            .frame(width: width*0.25, alignment: .leading)
            .fixedSize()
    }
    HStack(spacing: 0) {
        Text("Hello SwiftUI!")
            .frame(width: width*0.5, alignment: .leading)
        .fixedSize()
        Text("Baz")
            .frame(width: width*0.25, alignment: .leading)
        .fixedSize()
        Text("XYZ")
            .frame(width: width*0.25, alignment: .leading)
        .fixedSize()
    }                
}
}.padding()
```
With this code, you will get the right result:
![The right result](https://raw.githubusercontent.com/adtrevor/OneAxisGeometryReader/master/readme_ressources/horizontalgeometryreader.png)

You can also use `VGeometryReader` for a vertical geometry reader.

## State of this package
This is an experimental package that may break in the future when the internals of SwiftUI evolve.
View this package as a starting point, it can definetely be improved, so don't hesitate to open an issue or a pull request if you think something is missing or if you notice a bug.

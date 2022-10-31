# Bucker

Bucker is a simple package which is a parser of `tree` command output stirngs.

## Instlation

SwiftPM:

```swift
package.append(
    .package(url: "https://github.com/griffin-stewie/Bucker", from: "0.1.0")
)

package.targets.append(
    .target(name: "Foo", dependencies: [
        .product(name: "Bucker", package: "Bucker")
    ])
)
```

## How to use

```swift
let treeOutput = """
./
├── .DS_Store
├── Log/
│   ├── LogFormatter.swift
│   └── Logger.swift
└── Stream/
       └── Stream.swift
"""

let reports = Bucker(tree: treeOutput).parse()

print(reports)
/*
[
    Bucker.Report(indentLevel: 0, name: ".DS_Store", isDirectory: false, parents: []),
    Bucker.Report(indentLevel: 0, name: "Log", isDirectory: true, parents: []),
    Bucker.Report(indentLevel: 1, name: "LogFormatter.swift", isDirectory: false, parents: ["Log"]),
    Bucker.Report(indentLevel: 1, name: "Logger.swift", isDirectory: false, parents: ["Log"]),
    Bucker.Report(indentLevel: 0, name: "Stream", isDirectory: true, parents: []),
    Bucker.Report(indentLevel: 1, name: "Stream.swift", isDirectory: false, parents: ["Stream"]),
]
*/
```


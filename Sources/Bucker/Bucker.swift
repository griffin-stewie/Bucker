import Foundation


/// Bucker is parser of `tree` command output stirngs.
public struct Bucker {

    /// Type of parse result
    public struct Report: Equatable {
        /// Indent level
        public let indentLevel: UInt

        /// Name of item. this could be file name or directory name.
        public let name: String

        /// Returns whether the item is a directory.
        public let isDirectory: Bool

        /// Parents direcotry names
        public let parents: [String]
    }

    /// `tree -Fav --noreport`'s output string
    let tree: String

    private let directorySuffix = "/"
    private let rootDirectoryMark = "./"
    private let itemPrefixMark = "├── "
    private let lastItemPrefixMark = "└── "
    private let nestSpaces = String(repeating: " ", count: 4)


    /// Designed initializer
    /// - Parameter tree: `tree -Fav --noreport`'s output string will be parsed.
    public init(tree: String) {
        self.tree = tree
    }


    /// Parse input tree strings.
    /// - Returns: Array of report as parse results.
    public func parse() -> [Report] {
        var reports: [Report] = []
        parse { a in
            reports.append(a)
        }
        return reports
    }

    /// Parse input tree strings.
    /// - Parameter reporting: A closure which called each time when a new item founds.
    public func parse(reporting: @escaping (Report) -> ()) {
        /*
         Process by each line.

         Extract from the index position where either "├── " or "└── " exists to the end of the line. This is the name of the file or folder.
         Files or folders are distinguished by the presence of a "/" at the end of the name.

         Nest depth detection method.
         Number of times "│   " appears
         It is necessary to track whether the nesting is deeper or shallower than the previous process.
         */

        var currentIndentLevel: UInt = 0
        var parents: [String] =  []
        var lastDir: String? = nil
        tree.enumerateLines { line, _ in
            guard line != rootDirectoryMark else {
                return
            }

            guard let markRange = line.range(of: itemPrefixMark) ?? line.range(of: lastItemPrefixMark) else {
                return
            }

            let indentLevel = UInt(line[line.startIndex..<markRange.lowerBound].count / nestSpaces.count)

            let item = String(line[markRange.upperBound...])
            let isDirectory = item.hasSuffix(directorySuffix)
            let name = item.trimmingCharacters(in: CharacterSet(charactersIn: directorySuffix))

            if currentIndentLevel < indentLevel {
                // Depper
                parents.append(lastDir!)
            } else if currentIndentLevel > indentLevel {
                // Shallower

                let diff = currentIndentLevel - indentLevel
                parents.removeLast(Int(diff))
            } else {
                // same indent

            }

            if isDirectory {
                lastDir = name
            }

            currentIndentLevel = indentLevel

//            print(indentLevel, terminator: "\t")
//            print(line, terminator: "\t")
//            print("\(isDirectory ? "d" : "f")", terminator: "\t")
//            print(name)

            reporting(Report(indentLevel: indentLevel, name: name, isDirectory: isDirectory, parents: parents))
        }
    }
}

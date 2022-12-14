import XCTest
@testable import Bucker

final class BuckerTests: XCTestCase {
    func testParseNoneNestedDirectory() throws {
        let treeOutput = """
        ./
        ├── .DS_Store
        ├── .xcode-version
        ├── Package.swift
        ├── app/
        └── scripts/
        """

        let expects = [
            Bucker.Report(indentLevel: 0, name: ".DS_Store", isDirectory: false, parents: []),
            Bucker.Report(indentLevel: 0, name: ".xcode-version", isDirectory: false, parents: []),
            Bucker.Report(indentLevel: 0, name: "Package.swift", isDirectory: false, parents: []),
            Bucker.Report(indentLevel: 0, name: "app", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 0, name: "scripts", isDirectory: true, parents: []),
        ]

        let reports = Bucker(tree: treeOutput).parse()

        XCTAssertEqual(reports, expects)
    }

    func testDirectory() throws {
        let treeOutput = """
        ./
        ├── .DS_Store
        ├── Log/
        │   ├── LogFormatter.swift
        │   └── Logger.swift
        └── Stream/
            └── Stream.swift
        """

        let expects = [
            Bucker.Report(indentLevel: 0, name: ".DS_Store", isDirectory: false, parents: []),
            Bucker.Report(indentLevel: 0, name: "Log", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 1, name: "LogFormatter.swift", isDirectory: false, parents: ["Log"]),
            Bucker.Report(indentLevel: 1, name: "Logger.swift", isDirectory: false, parents: ["Log"]),
            Bucker.Report(indentLevel: 0, name: "Stream", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 1, name: "Stream.swift", isDirectory: false, parents: ["Stream"]),
        ]

        let reports = Bucker(tree: treeOutput).parse()

        XCTAssertEqual(reports, expects)
    }

    func testParseNestedDirectory() throws {
        let treeOutput = """
        ./
        ├── .DS_Store
        ├── Log/
        │   ├── LogFormatter.swift
        │   └── Logger.swift
        ├── Stream/
        │   └── Stream.swift
        ├── XopenCore/
        │   ├── Errors.swift
        │   ├── Extensions/
        │   │   ├── FileManager+Extensions.swift
        │   │   ├── String+Extensions.swift
        │   │   └── URL+Extensions.swift
        │   ├── History.swift
        │   ├── InstalledXcode.swift
        │   ├── MatchingType.swift
        │   ├── Pathfinder.swift
        │   ├── UserSpecificXcodeVersion.swift
        │   ├── Version.swift
        │   ├── VersionPlist.swift
        │   ├── XcodeVersionFilePathfinder.swift
        │   ├── Xopen+internals.swift
        │   └── Xopen.swift
        └── xopen/
            ├── .DS_Store
            ├── Commands/
            │   ├── .DS_Store
            │   ├── RootCommand.swift
            │   ├── RootCommandOptions.swift
            │   └── SubCommands/
            │       ├── .DS_Store
            │       ├── Default/
            │       │   └── DefaultOpenCommand.swift
            │       ├── History/
            │       │   ├── HistoryCommand.swift
            │       │   └── HistoryCommandOptions.swift
            │       ├── Open/
            │       │   ├── OpenCommand.swift
            │       │   └── OpenCommandOptions.swift
            │       ├── Read/
            │       │   ├── ReadCommand.swift
            │       │   └── ReadCommandOptions.swift
            │       └── Write/
            │           ├── WriteCommand.swift
            │           └── WriteCommandOptions.swift
            └── Extensions/
                ├── Path+Extensions.swift
                └── UserSpecificXcodeVersion+Extensions.swift
        """

        let expects = [
            Bucker.Report(indentLevel: 0, name: ".DS_Store", isDirectory: false, parents: []),
            Bucker.Report(indentLevel: 0, name: "Log", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 1, name: "LogFormatter.swift", isDirectory: false, parents: ["Log"]),
            Bucker.Report(indentLevel: 1, name: "Logger.swift", isDirectory: false, parents: ["Log"]),
            Bucker.Report(indentLevel: 0, name: "Stream", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 1, name: "Stream.swift", isDirectory: false, parents: ["Stream"]),
            Bucker.Report(indentLevel: 0, name: "XopenCore", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 1, name: "Errors.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "Extensions", isDirectory: true, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 2, name: "FileManager+Extensions.swift", isDirectory: false, parents: ["XopenCore", "Extensions"]),
            Bucker.Report(indentLevel: 2, name: "String+Extensions.swift", isDirectory: false, parents: ["XopenCore", "Extensions"]),
            Bucker.Report(indentLevel: 2, name: "URL+Extensions.swift", isDirectory: false, parents: ["XopenCore", "Extensions"]),
            Bucker.Report(indentLevel: 1, name: "History.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "InstalledXcode.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "MatchingType.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "Pathfinder.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "UserSpecificXcodeVersion.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "Version.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "VersionPlist.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "XcodeVersionFilePathfinder.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "Xopen+internals.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 1, name: "Xopen.swift", isDirectory: false, parents: ["XopenCore"]),
            Bucker.Report(indentLevel: 0, name: "xopen", isDirectory: true, parents: []),
            Bucker.Report(indentLevel: 1, name: ".DS_Store", isDirectory: false, parents: ["xopen"]),
            Bucker.Report(indentLevel: 1, name: "Commands", isDirectory: true, parents: ["xopen"]),
            Bucker.Report(indentLevel: 2, name: ".DS_Store", isDirectory: false, parents: ["xopen", "Commands"]),
            Bucker.Report(indentLevel: 2, name: "RootCommand.swift", isDirectory: false, parents: ["xopen", "Commands"]),
            Bucker.Report(indentLevel: 2, name: "RootCommandOptions.swift", isDirectory: false, parents: ["xopen", "Commands"]),
            Bucker.Report(indentLevel: 2, name: "SubCommands", isDirectory: true, parents: ["xopen", "Commands"]),
            Bucker.Report(indentLevel: 3, name: ".DS_Store", isDirectory: false, parents: ["xopen", "Commands", "SubCommands"]),
            Bucker.Report(indentLevel: 3, name: "Default", isDirectory: true, parents: ["xopen", "Commands", "SubCommands"]),
            Bucker.Report(indentLevel: 4, name: "DefaultOpenCommand.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Default"]),
            Bucker.Report(indentLevel: 3, name: "History", isDirectory: true, parents: ["xopen", "Commands", "SubCommands"]),
            Bucker.Report(indentLevel: 4, name: "HistoryCommand.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "History"]),
            Bucker.Report(indentLevel: 4, name: "HistoryCommandOptions.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "History"]),
            Bucker.Report(indentLevel: 3, name: "Open", isDirectory: true, parents: ["xopen", "Commands", "SubCommands"]),
            Bucker.Report(indentLevel: 4, name: "OpenCommand.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Open"]),
            Bucker.Report(indentLevel: 4, name: "OpenCommandOptions.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Open"]),
            Bucker.Report(indentLevel: 3, name: "Read", isDirectory: true, parents: ["xopen", "Commands", "SubCommands"]),
            Bucker.Report(indentLevel: 4, name: "ReadCommand.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Read"]),
            Bucker.Report(indentLevel: 4, name: "ReadCommandOptions.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Read"]),
            Bucker.Report(indentLevel: 3, name: "Write", isDirectory: true, parents: ["xopen", "Commands", "SubCommands"]),
            Bucker.Report(indentLevel: 4, name: "WriteCommand.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Write"]),
            Bucker.Report(indentLevel: 4, name: "WriteCommandOptions.swift", isDirectory: false, parents: ["xopen", "Commands", "SubCommands", "Write"]),
            Bucker.Report(indentLevel: 1, name: "Extensions", isDirectory: true, parents: ["xopen"]),
            Bucker.Report(indentLevel: 2, name: "Path+Extensions.swift", isDirectory: false, parents: ["xopen", "Extensions"]),
            Bucker.Report(indentLevel: 2, name: "UserSpecificXcodeVersion+Extensions.swift", isDirectory: false, parents: ["xopen", "Extensions"]),
        ]

        let reports = Bucker(tree: treeOutput).parse()

        XCTAssertEqual(reports, expects)
    }
}

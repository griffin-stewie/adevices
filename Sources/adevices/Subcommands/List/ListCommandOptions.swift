import Foundation
import ArgumentParser
import Core
import Path

struct ListCommandOptions: ParsableArguments {
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: ArgumentHelp("platform"))
    var platform: [DevicesStore.Platform] = DevicesStore.Platform.allCases

    @Option(name: .shortAndLong, help: ArgumentHelp("output format"))
    var format: Writer.Format = .markdownTable

    @Flag(name: [.customLong("pretty-print")], inversion: .prefixedEnableDisable, help: ArgumentHelp("Pretty printed output"))
    var prettyPrint: Bool = true

    @Option(name: .long, help: ArgumentHelp("Path to device_traits.db"), completion: .file(extensions: ["db"]))
    var databasePath: Path?

    @Option(name: .long, help: ArgumentHelp("Path to Xcode.app"), completion: .file(extensions: ["app"]))
    var xcodeAppPath: Path?
}


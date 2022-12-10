import Foundation
import TSCBasic
import ArgumentParser
import Core

@main
struct ListCommand: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "adevices",
        abstract: "Get list of Apple devices from Xcode",
        version: "0.1.0"
    )

    @OptionGroup()
    var options: ListCommandOptions

    func run() async throws {
        try await run(options: options)
    }
}

extension ListCommand {
    private func run(options: ListCommandOptions) async throws {
        let store = try deviceStore(options: options)
        let devices = try await store.fetchAll().sorted(by: \.productDescription, oreder: .orderedDescending)
        try output(devices: devices, options: options, stream: stdoutStream)
    }

    private func deviceStore(options: ListCommandOptions) throws -> DevicesStore {
        // Instantiate DeviceStore with specified database if its path is given
        if let db = options.databasePath {
            return try DevicesStore(databaseURL: db.url)
        }

        // Instantiate DeviceStore for the specified platform from Xcode.app in the specified path.
        if let xcode = options.xcodeAppPath {
            return try DevicesStore(xcode: xcode.url, platform: options.platform)
        }

        // Instantiate DeviceStore for the specified platform from active Xcode.app.
        return try DevicesStore(platform: options.platform)
    }

    private func output(devices: [Device], options: ListCommandOptions, stream: ThreadSafeOutputByteStream) throws {
        switch options.format {
        case .tsv:
            let (header, rows) = transformColumnBasedData(devices: devices)
            let writer = CSVWriter(delimiter: "\t")
            try writer.write(header: header, rows: rows, stream: stream)
        case .csv:
            let (header, rows) = transformColumnBasedData(devices: devices)
            let writer = CSVWriter(delimiter: ",")
            try writer.write(header: header, rows: rows, stream: stream)
        case .markdownTable:
            let (header, rows) = transformColumnBasedData(devices: devices)
            let writer = MarkdownTableWriter(needsPrettyPrint: options.prettyPrint)
            try writer.write(header: header, rows: rows, stream: stream)
        case .json:
            let encoder = JSONEncoder()
            if options.prettyPrint {
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            }

            let data = try encoder.encode(devices)

            stream <<<< String(data: data, encoding: .utf8)!
            stream.flush()
        }
    }

    private func transformColumnBasedData(devices: [Device]) -> (header: [String], rows: [[String]]) {
        let header = [Device.CodingKeys.productType.rawValue, Device.CodingKeys.productDescription.rawValue]
        let rows = devices.map {
            [$0.productType, $0.productDescription]
        }

        return (header, rows)
    }
}
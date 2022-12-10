import ArgumentParser
import Foundation
import TSCBasic
import TSCUtility

import class CSV.CSVWriter

struct Writer {
    enum Format: ExpressibleByArgument {

        static var availableFormats = [
            "tsv",
            "csv",
            "markdown-table",
            "json",
        ]

        var defaultValueDescription: String {
            switch self {
            case .tsv:
                return "tsv"
            case .csv:
                return "csv"
            case .markdownTable:
                return "markdown-table"
            case .json:
                return "json"
            }
        }

        static var allValueStrings: [String] {
            availableFormats
        }

        static var defaultCompletionKind: CompletionKind {
            .list(allValueStrings)
        }

        case tsv
        case csv
        case markdownTable
        case json

        init?(argument: String) {
            switch argument {
            case "tsv":
                self = .tsv
            case "csv":
                self = .csv
            case "markdown-table":
                self = .markdownTable
            case "json":
                self = .json
            default:
                return nil
            }
        }

        func write(header: [String], rows: [[String]], stream: ThreadSafeOutputByteStream = stdoutStream, needsPrettyPrint: Bool = true) throws {

            let writer: Writable

            switch self {
            case .tsv:
                writer = CSVWriter(delimiter: "\t")
            case .csv:
                writer = CSVWriter(delimiter: ",")
            case .markdownTable:
                writer = MarkdownTableWriter(needsPrettyPrint: needsPrettyPrint)
            case .json:
                fatalError()
            }

            try writer.write(header: header, rows: rows, stream: stream)
        }
    }

    static func write(format: Writer.Format, header: [String], rows: [[String]], stream: ThreadSafeOutputByteStream = stdoutStream) throws {
        try format.write(header: header, rows: rows, stream: stream)
    }
}

extension Writer.Format: Equatable {
}

extension Writer.Format {
    var fileExtension: String {
        switch self {
        case .tsv:
            return "tsv"
        case .csv:
            return "csv"
        case .markdownTable:
            return "md"
        case .json:
            return "json"
        }
    }
}

infix operator <<<<: StreamingPrecedence
precedencegroup StreamingPrecedence {
    associativity: left
}

@discardableResult
public func <<<< (stream: WritableByteStream, value: CustomStringConvertible) -> WritableByteStream {
    stream <<< value.description
    stream <<< "\n"
    return stream
}

@discardableResult
public func <<<< (stream: WritableByteStream, value: ByteStreamable & CustomStringConvertible) -> WritableByteStream {
    stream <<< value
    stream <<< "\n"
    return stream
}

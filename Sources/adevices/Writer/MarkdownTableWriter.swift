import Foundation
import TSCBasic
import TSCUtility

struct MarkdownTableWriter: Writable {
    let needsPrettyPrint: Bool


func write(header: [String], rows: [[String]], stream: TSCBasic.ThreadSafeOutputByteStream) throws {
        var data: [[String]] = rows
        data.insert(header, at: 0)
        try write(data: data, stream: stream)
    }

    /// Output a markdown table string from given data into stream
    /// - Parameters:
    ///   - data: data include header
    ///   - stream: output stream
    /// - Throws: may happen.
    func write(data: [[String]], stream: ThreadSafeOutputByteStream) throws {
        let str = table(data: data, prettyPrint: needsPrettyPrint)
        stream <<<< str
        stream.flush()
    }


    /// Generate a markdown table string from given data
    /// - Parameters:
    ///   - data: data include header
    ///   - prettyPrint: pretty print
    /// - Returns: Generate a markdown table string from given data
    func table(data: [[String]], prettyPrint: Bool) -> String {

        var temp = data
        let header = temp.removeFirst()

        let maxTextLengthEachColumn: [Int] = {
            let target: [[String]]
            if prettyPrint {
                target = data.transposed()
            } else {
                target = [header].transposed()
            }

            return target.map { columnItems in
                columnItems.map {
                    $0.count
                }
                .max() ?? 0
            }
        }()

        return table(header: header, rows: temp, maxLengthEachColumn: maxTextLengthEachColumn, prettyPrint: prettyPrint)
    }
}

extension MarkdownTableWriter {
    // print header separator
    fileprivate func printHeaderSeparator<Target>(maxLengthEachColumn: [Int], to output: inout Target) where Target: TextOutputStream {
        let extraPadForSpace = 2
        let elements = maxLengthEachColumn.map { String(repeating: "-", count: $0 + extraPadForSpace) }

        print("|", terminator: "", to: &output)
        print(elements.joined(separator: "|"), terminator: "", to: &output)
        print("|", terminator: "\n", to: &output)
    }

    // print row
    fileprivate func printRow<Target>(row: [String], to output: inout Target) where Target: TextOutputStream {
        print("| ", terminator: "", to: &output)
        print(row.joined(separator: " | "), terminator: "", to: &output)
        print(" |", terminator: "\n", to: &output)
    }

    // print header
    fileprivate func printRow<Target>(row: [String], maxLengthEachColumn: [Int], to output: inout Target) where Target: TextOutputStream {

        let paddedRow = row.enumerated().map { (index, text) -> String in
            text.padding(toLength: maxLengthEachColumn[index], withPad: " ", startingAt: 0)
        }
        print("| ", terminator: "", to: &output)
        print(paddedRow.joined(separator: " | "), terminator: "", to: &output)
        print(" |", terminator: "\n", to: &output)
    }

    fileprivate func table(header: [String], rows: [[String]], maxLengthEachColumn: [Int], prettyPrint: Bool) -> String {
        var output: String = ""

        let formatedHeader: [String] = {
            guard prettyPrint else {
                return header
            }

            return header.enumerated().map { (index, text) -> String in
                text.padding(toLength: maxLengthEachColumn[index], withPad: " ", startingAt: 0)
            }
        }()

        let formatedRows: [[String]] = {
            guard prettyPrint else {
                return rows
            }

            return rows.map { row in
                return row.enumerated().map { (index, text) -> String in
                    text.padding(toLength: maxLengthEachColumn[index], withPad: " ", startingAt: 0)
                }
            }
        }()

        printRow(row: formatedHeader, to: &output)
        printHeaderSeparator(maxLengthEachColumn: maxLengthEachColumn, to: &output)
        for row in formatedRows {
            printRow(row: row, to: &output)
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

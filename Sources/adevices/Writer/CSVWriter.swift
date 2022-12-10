import Foundation
import TSCBasic
import TSCUtility

import class CSV.CSVWriter

protocol Writable {
    func write(header: [String], rows: [[String]], stream: ThreadSafeOutputByteStream) throws
}

struct CSVWriter: Writable {

    let delimiter: String

    init(delimiter: String = ",") {
        self.delimiter = delimiter
    }

    func write(header: [String], rows: [[String]], stream: ThreadSafeOutputByteStream) throws {
        let csv = try! CSV.CSVWriter(stream: .toMemory(), delimiter: self.delimiter)

        defer {
            csv.stream.close()

            // Get a String
            let csvData = csv.stream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
            let csvString = String(data: csvData, encoding: .utf8)!

            stream <<< csvString
            stream <<< "\n"
            stream.flush()
        }

        // Write header
        try csv.write(row: header)


        // Write rows
        try rows.forEach { (row) in
            csv.beginNewRow()
            try csv.write(row: row)
        }
    }
}

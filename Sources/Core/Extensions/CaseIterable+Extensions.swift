import Foundation

extension CaseIterable {
    public static var allCasesDescription: String {
        return self.allCasesDescription(surrounded: "", separator: ", ")
    }

    public static func allCasesDescription(surrounded: String = "'", separator: String = ", ") -> String {
        return self.allCases
            .map { String(describing: $0) }
            .map { "\(surrounded)\($0)\(surrounded)" }
            .joined(separator: separator)
    }
}
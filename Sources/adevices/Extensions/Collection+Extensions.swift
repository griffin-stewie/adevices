import Foundation

extension Collection where Self.Iterator.Element: RandomAccessCollection {

    /// Swapping Rows and Columns in a 2D Array
    /// - Returns: transposed 2D Array
    public func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map { $0[index] }
        }
    }
}

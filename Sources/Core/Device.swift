import Foundation
import GRDB

public struct Device: Codable, FetchableRecord, TableRecord {
    public static var databaseTableName: String {
        "Devices"
    }

    /// `iPhone14,5`
    public var productType: String

    /// `iPhone 13`
    public var productDescription: String

    public enum CodingKeys: String, CodingKey {
        case productType = "ProductType"
        case productDescription = "ProductDescription"
    }
}

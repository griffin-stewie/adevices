import Foundation
import GRDB

public struct DevicesStore {
    public let databaseURL: URL
    private let dbQueue: DatabaseQueue

    public init(databaseURL: URL) throws {
        self.databaseURL = databaseURL
        var config = Configuration()
        config.readonly = true
        self.dbQueue = try DatabaseQueue(path: databaseURL.path, configuration: config)
    }

    public func fetchAll() async throws -> [Device] {
        return try await withCheckedThrowingContinuation { continuation in
            dbQueue.asyncRead { result in
                do {
                    let db = try result.get()
                    let all = try Device.fetchAll(db)//.sorted(by: { a, b in
//                        a.productType.localizedStandardCompare(b.productType) == .orderedDescending
//                    })

                    continuation.resume(returning: all)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension DevicesStore {
    public enum Platform: String, CaseIterable {
        case iPhone = "iphone"
        case watch = "watch"
        case tv = "tv"

        public var name: String {
            switch self {
            case .iPhone:
                return "iPhoneOS"
            case .watch:
                return "WatchOS"
            case .tv:
                return "AppleTVOS"
            }
        }

        public var pathFromXcode: String {
            "Contents/Developer/Platforms/\(name).platform/usr/standalone/device_traits.db"
        }

        public func databaseURL(xcode: URL) -> URL {
            return xcode.appendingPathComponent(pathFromXcode)
        }
    }
}

public extension DevicesStore {
    init(xcode: URL, platform: Platform = .iPhone) throws {
        let dbURL = platform.databaseURL(xcode: xcode)
        try self.init(databaseURL: dbURL)
    }
}

extension Sequence where Element == Device {
    public func sorted<T: StringProtocol>(by keyPath: KeyPath<Element, T>, oreder: ComparisonResult = .orderedAscending) -> [Element] {
        return sorted { a, b in
            a[keyPath: keyPath].compare(b[keyPath: keyPath], options: [.numeric], locale: .current) == oreder
        }
    }
}

// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "adevices",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.2.0"),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", exact: "0.4.0"),
        .package(url: "https://github.com/mxcl/Path.swift.git", exact: "1.4.0"),
        .package(url: "https://github.com/groue/GRDB.swift", exact: "6.5.0"),
        .package(url: "https://github.com/yaslab/CSV.swift.git", exact: "2.4.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "adevices",
            dependencies: [
                "Core",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
                .product(name: "Path", package: "Path.swift"),
                .product(name: "CSV", package: "CSV.swift"),
            ]),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
            ]),
        .testTarget(
            name: "adevicesTests",
            dependencies: ["adevices"]),
    ]
)

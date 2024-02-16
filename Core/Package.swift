// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "API",
            targets: ["API"]
        ),
        .library(
            name: "Design",
            targets: ["Design"]
        ),
        .library(
            name: "Model",
            targets: ["Model"]
        ),
    ],
    dependencies: [
        .package(path: "../Base"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.12.0"
        ),
    ],
    targets: [
        .target(name: "API"),
        .testTarget(
            name: "APITests",
            dependencies: ["API"]
        ),
        .target(
            name: "Model",
            dependencies: [
                "API",
                .product(name: "Base", package: "Base"),
            ]
        ),
        .target(
            name: "Design",
            dependencies: [
                "API", "Model",
                .product(name: "Base", package: "Base"),
            ]
        ),
        .testTarget(
            name: "DesignTests",
            dependencies: [
                "Design",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)

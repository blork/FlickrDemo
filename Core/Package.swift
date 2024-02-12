// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        .library(
            name: "Design",
            targets: ["Design"]
        ),
    ],
    dependencies: [
        .package(path: "../Base"),
    ],
    targets: [
        .target(name: "Network"),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
        .target(
            name: "Design",
            dependencies: [
                .product(name: "Base", package: "Base"),
            ]
        ),
        .testTarget(
            name: "DesignTests",
            dependencies: ["Design"]
        ),
    ]
)

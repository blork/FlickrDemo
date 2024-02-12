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
    ],
    targets: [
        .target(
            name: "Network"),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
    ]
)

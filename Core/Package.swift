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
    ],
    targets: [
        .target(name: "API"),
        .testTarget(
            name: "APITests",
            dependencies: ["API"]
        ),
        .target(
            name: "Model",
            dependencies: ["API"]
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
            dependencies: ["Design"]
        ),
    ]
)

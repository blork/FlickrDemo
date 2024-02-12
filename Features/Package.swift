// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "PhotoList",
            targets: ["PhotoList"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "PhotoList",
            dependencies: [
                .product(name: "Network", package: "Core"),
                .product(name: "Design", package: "Core"),
            ]
        ),
        .testTarget(
            name: "PhotoListTests",
            dependencies: ["PhotoList"]
        ),
    ]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "BrowsePhotos",
            targets: ["BrowsePhotos"]
        ),
        .library(
            name: "Nearby",
            targets: ["Nearby"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.12.0"
        ),
    ],
    targets: [
        .target(
            name: "BrowsePhotos",
            dependencies: [
                .product(name: "API", package: "Core"),
                .product(name: "Design", package: "Core"),
                .product(name: "Model", package: "Core"),
            ]
        ),
        .testTarget(
            name: "BrowsePhotosTests",
            dependencies: [
                "BrowsePhotos",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
        .target(
            name: "Nearby",
            dependencies: [
                .product(name: "API", package: "Core"),
                .product(name: "Design", package: "Core"),
                .product(name: "Model", package: "Core"),
            ]
        ),
        .testTarget(
            name: "NearbyTests",
            dependencies: [
                "Nearby",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)

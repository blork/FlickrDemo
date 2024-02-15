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
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "BrowsePhotos",
            dependencies: [
                .product(name: "Network", package: "Core"),
                .product(name: "Design", package: "Core"),
                .product(name: "Model", package: "Core"),
            ]
        ),
        .testTarget(
            name: "BrowsePhotosTests",
            dependencies: ["BrowsePhotos"]
        ),
    ]
)

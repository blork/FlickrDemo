// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Flickr",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Flickr",
            targets: ["Flickr"]),
    ],
    targets: [
        .target(
            name: "Flickr"),
        .testTarget(
            name: "FlickrTests",
            dependencies: ["Flickr"]),
    ]
)

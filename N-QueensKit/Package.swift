// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "N-QueensKit",
    products: [
        .library(
            name: "N-QueensKit",
            targets: ["Data", "Domain", "Presentation"]
        ),
    ],
    targets: [
        .target(
            name: "Data"
        ),
        .target(
            name: "Domain"
        ),
        .target(
            name: "Presentation"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

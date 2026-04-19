// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: Array<SwiftSetting> = [
    .swiftLanguageMode(.v6),
    .defaultIsolation(MainActor.self)
]

let package = Package(
    name: "N-QueensKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
//        .library(name: "Common", targets: ["Common"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "Domain", targets: ["Domain"]),
//        .library(name: "Mocks", targets: ["Mocks"]),
        .library(name: "Presentation", targets: ["Presentation"]),
    ],
    targets: [
        .target(
            name: "Data",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Presentation",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

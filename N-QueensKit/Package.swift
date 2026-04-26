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
        .library(name: "Infrastructure", targets: ["Infrastructure"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Mocks", targets: ["Mocks"]),
        .library(name: "Presentation", targets: ["Presentation"]),
    ],
    targets: [
        .target(
            name: "Infrastructure",
            dependencies: ["Domain"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Domain",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Mocks",
            dependencies: ["Domain"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Presentation",
            dependencies: ["Domain"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation", "Domain", "Mocks"],
            path: "Tests/Presentation",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain", "Mocks"],
            path: "Tests/Domain",
            swiftSettings: swiftSettings
        ),
    ],
    swiftLanguageModes: [.v6]
)

// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NopiCore",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14)
    ],
    products: [
        .library(name: "NopiCore", targets: ["NopiCore"])
    ],
    targets: [
        .target(
            name: "NopiCore",
            path: "Sources/NopiCore"
        ),
        .testTarget(
            name: "NopiCoreTests",
            dependencies: ["NopiCore"],
            path: "Tests/NopiCoreTests"
        )
    ]
)

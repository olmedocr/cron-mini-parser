// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CronMiniParser",
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .upToNextMinor(from: "0.4.3")
        ),
    ],
    targets: [
        .executableTarget(
            name: "CronMiniParser",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "CronMiniParserTests",
            dependencies: ["CronMiniParser"]),
    ]
)

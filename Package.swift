// swift-tools-version:6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [
        .iOS("27.0"),
        .macOS("27.0")
    ],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: []),
    ]
)

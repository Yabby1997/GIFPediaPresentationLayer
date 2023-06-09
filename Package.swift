// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GIFPediaPresentationLayer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GIFPediaPresentationLayer",
            targets: ["GIFPediaPresentationLayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Yabby1997/GIFPediaService", from: "0.4.2"),
    ],
    targets: [
        .target(
            name: "GIFPediaPresentationLayer",
            dependencies: [
                .product(name: "GIFPediaService", package: "GIFPediaService")
            ]),
    ]
)

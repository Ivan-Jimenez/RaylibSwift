// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Raylib",
    products: [
        .library(name: "Raylib", targets: ["Raylib"]),
        .library(name: "RaylibC", targets: ["RaylibC"]),
    ],
    targets: [
        .executableTarget(name: "Example", dependencies: ["Raylib"]),
        .target(name: "Raylib", dependencies: ["RaylibC"]),
        .systemLibrary(name: "RaylibC")
    ]
)

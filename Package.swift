// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZakatFatoora",
    platforms: [
    
        .iOS(.v13)
    
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZakatFatoora",
            targets: ["ZakatFatoora"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ZakatFatoora",
            dependencies: []),
    ]
)

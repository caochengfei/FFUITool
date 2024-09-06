// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFUITool",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FFUITool",
            targets: ["FFUITool"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "FFUITool",
                dependencies: [
                    .product(name: "SnapKit", package: "SnapKit")
                ],
                path: "FFUITool/Classes"
//                resources: [
//                    .process("FFUITool/Classes")
//                ]
               ),
//        .testTarget(
//            name: "FFUIToolTests",
//            dependencies: ["FFUITool"]),
    ]
)

// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDSView",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SDSView",
            targets: ["SDSView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/tyagishi/SDSNSUIBridge", from: "1.2.0"),
        .package(url: "https://github.com/tyagishi/SDSViewExtension", from: "4.2.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.56.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SDSView",
            dependencies: ["SDSNSUIBridge", "SDSViewExtension"],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "SDSViewTests",
            dependencies: ["SDSView"]),
    ]
)

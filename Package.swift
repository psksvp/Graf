// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Graf",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
				.package(name: "CommonSwift", url: "https://github.com/psksvp/CommonSwift", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Graf",
            dependencies: ["SDL2", "CCairo", "CommonSwift"]),
        .testTarget(
            name: "GrafTests",
            dependencies: ["Graf"]),		
				.systemLibrary(name: "CCairo",
				            pkgConfig: "cairo",
				            providers: [
				                .brew(["cairo"]),
				                .apt(["libcairo2-dev"])
				            ]),
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev"])
            ]),
				.target(name: "SDL2", dependencies: ["CSDL2"])
    ]
)

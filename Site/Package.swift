// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Doodle",
    products: [
        .executable(name: "Doodle", targets: ["Doodle"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.1.0"),
        .package(path: "/Users/joeblau/Developer/joeblau/src/blau-theme")
    ],
    targets: [
        .target(
            name: "Doodle",
            dependencies: ["Publish", "BlauTheme"]
        )
    ]
)

// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BenjiJailbreak",
    platforms: [.iOS(.v14)],
    products: [
        .executable(name: "BenjiJailbreak", targets: ["BenjiJailbreak"])
    ],
    targets: [
        .executableTarget(
            name: "BenjiJailbreak",
            path: "Sources",
            sources: ["BenjiJailbreak.swift"],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("SwiftUI"),
                .linkedFramework("Foundation"),
                .linkedFramework("IOKit"),
                .linkedFramework("Accessibility")   // <- add this
            ]
        )
    ]
)
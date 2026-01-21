// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import EnvPlugin
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        productTypes: [
            "SwiftHTMLtoMarkdown": .framework,
            "EmojiText": .framework,
        ],
        baseSettings: .settings(configurations: .default)
    )
#endif

let package = Package(
    name: "Tuist",
    dependencies: [
        .package(url: "https://github.com/ActuallyTaylor/SwiftHTMLToMarkdown", from: "1.1.1"),
        .package(url: "https://github.com/divadretlaw/EmojiText", from: "4.4.0"),
    ]
)

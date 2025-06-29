// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import EnvPlugin
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
         productTypes: [
            "Kingfisher": .framework,
            "SDWebImage": .framework,
            "Neumorphic": .framework,
            "SwiftUIIntrospect": .framework,
            "EmojiText": .framework,
            "SwiftHTMLtoMarkdown": .framework,
         ],
//        productTypes: [:],
        baseSettings: .settings(configurations: .default)
    )
#endif

let package = Package(
    name: "Tuist",
    dependencies: [
        // Add your own dependencies here:
         .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.1.3"),
         .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.20.0"),
         .package(url: "https://github.com/costachung/neumorphic", from: "2.0.7"),
         .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "1.3.0"),
         .package(url: "https://github.com/divadretlaw/EmojiText", from: "4.2.0"),
         .package(url: "https://github.com/ActuallyTaylor/SwiftHTMLToMarkdown", from: "1.1.1"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    ]
)

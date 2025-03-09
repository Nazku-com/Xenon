import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.UIComponent),
    product: .framework, targets: [
        .makeExampleApp(name: ModulePaths.feature(.UIComponent).name, dependencies: [
            .target(name: ModulePaths.feature(.UIComponent).name),
            ModulePaths.feature(.FediverseFeature).dependency,
        ])
],
    dependencies: [
        ModulePaths.feature(.NetworkingFeature).dependency,
        .external(name: "SDWebImage"),
        .external(name: "Neumorphic"),
        .external(name: "Kingfisher"),
        .external(name: "SwiftUIIntrospect"),
        .external(name: "EmojiText"),
        .external(name: "SwiftHTMLtoMarkdown"),
    ]
)

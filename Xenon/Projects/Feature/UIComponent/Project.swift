import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.UIComponent),
    product: .framework, targets: [
        .makeExampleApp(name: ModulePaths.feature(.UIComponent).name, dependencies: [
            .target(name: ModulePaths.feature(.UIComponent).name)
        ])
],
    dependencies: [
        ModulePaths.feature(.Sugar).dependency,
        .external(name: "EmojiText"),
    ]
)

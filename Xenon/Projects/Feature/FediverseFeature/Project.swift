import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.FediverseFeature),
    product: .framework, targets: [
        .makeExampleApp(name: ModulePaths.feature(.FediverseFeature).name, dependencies: [
            .target(name: ModulePaths.feature(.FediverseFeature).name)
        ])
],
    dependencies: [
        ModulePaths.feature(.Sugar).dependency,
        ModulePaths.feature(.NetworkingFeature).dependency
    ]
)

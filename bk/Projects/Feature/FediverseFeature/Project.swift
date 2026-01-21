import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.FediverseFeature),
    product: .framework, targets: [],
    dependencies: [
        ModulePaths.feature(.NetworkingFeature).dependency
    ]
)

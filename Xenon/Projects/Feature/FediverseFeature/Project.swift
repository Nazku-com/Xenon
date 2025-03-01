import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.FediverseFeature),
    product: .framework, targets: [],
    dependencies: [
        .external(name: "Alamofire"),
        ModulePaths.feature(.NetworkingFeature).dependency
    ]
)

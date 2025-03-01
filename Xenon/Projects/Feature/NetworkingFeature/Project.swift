import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.NetworkingFeature),
    product: .framework, targets: [
        .makeExampleApp(name: ModulePaths.feature(.NetworkingFeature).name, dependencies: [
            .target(name: ModulePaths.feature(.NetworkingFeature).name)
        ])
    ],
    dependencies: [
        .external(name: "Alamofire")
    ]
)

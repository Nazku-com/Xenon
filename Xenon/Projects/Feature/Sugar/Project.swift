import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.Sugar),
    product: .framework, targets: [],
    dependencies: [
        .external(name: "SwiftHTMLtoMarkdown"),
    ]
)

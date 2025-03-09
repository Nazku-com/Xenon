import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin
import EnvPlugin

let targets: [Target] = [
    .makeApp(name: ProjectInfo.name, dependencies: [
        ModulePaths.feature(.FediverseFeature).dependency,
        ModulePaths.feature(.UIComponent).dependency,
    ])
].addTest()

let project = Project(
    name: ProjectInfo.name,
    settings: ProjectInfo.settings,
    targets: targets,
    schemes: ProjectInfo.schemes
)

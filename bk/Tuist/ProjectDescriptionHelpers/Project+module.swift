import Foundation
import ProjectDescription
import UtilityPlugin
import EnvPlugin

public extension Project {
    
    static func module(
        _ module: ModulePaths,
        product: Product,
        options: Options = .options(),
        packages: [Package] = [],
        targets: [Target] = [],
        dependencies: [TargetDependency] = [],
        schemes: [Scheme] = [],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = []
    ) -> Project {
        var moduleTargets: [Target] = targets +
        [
            .make(
                name: module.name,
                product: product,
                bundleId: ProjectInfo.bundleIdPrefix + "module." + module.name,
                infoPlist: .default,
                sources: ["Sources/**"],
                resources: ["Resources/**"],
                dependencies: dependencies
            )
        ]
        return Project(
            name: module.name,
            organizationName: ProjectInfo.organizationName,
            options: options,
            packages: packages,
            settings: ProjectInfo.settings,
            targets: moduleTargets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: .default
        )
    }
}

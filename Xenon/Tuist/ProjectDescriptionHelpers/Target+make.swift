import ProjectDescription
import UtilityPlugin
import EnvPlugin

extension Target {
    public static func makeApp(name: String, dependencies: [TargetDependency] = []) -> Target {
        .make(
            name: name,
            product: .app,
            bundleId: ProjectInfo.bundleIdPrefix + name,
            infoPlist: .file(path: "Support/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies
        )
    }
    
    public static func makeExampleApp(name: String, dependencies: [TargetDependency] = []) -> Target {
        .make(
            name: "example."+name,
            product: .app,
            bundleId: ProjectInfo.bundleIdPrefix + "example." + name,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: dependencies
        )
    }
}

extension [Target] {
    public func addTest() -> [Target] {
        let name = self.first?.name ?? ""
        let bundleId = self.first?.bundleId ?? ""
        var newValue = self
        newValue.append(
            .make(
                name: name+"Test",
                destinations: .iOS,
                product: .unitTests,
                bundleId: bundleId + ".DashboardTests",
                infoPlist: .default,
                sources: ["Tests/**"],
                resources: [],
                dependencies:
                    self.compactMap({ target -> TargetDependency? in
                            .target(name: target.name)
                    })
            )
        )
        return newValue
    }
}

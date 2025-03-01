import ProjectDescription

let tuist = Tuist(
    plugins: [
        .local(path: .relativeToRoot("Plugin/EnvPlugin")),
        .local(path: .relativeToRoot("Plugin/UtilityPlugin"))
    ]
)

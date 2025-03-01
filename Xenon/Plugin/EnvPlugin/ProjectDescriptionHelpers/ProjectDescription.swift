import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToXCConfig(type: ProjectDeployTarget, name: String) -> Self {
        return .relativeToRoot("XCConfig/\(name)/\(type.rawValue).xcconfig")
    }
    static var shared: Self {
        return .relativeToRoot("XCConfig/Shared.xcconfig")
    }
}

public enum ProjectDeployTarget: String {
    case dev = "DEV"
    case stage = "STAGE"
    case prod = "PROD"
    
    public var configurationName: ConfigurationName {
        ConfigurationName.configuration(self.rawValue)
    }
}

public extension ConfigurationName {
    static var dev: ConfigurationName { configuration(ProjectDeployTarget.dev.rawValue) }
    static var stage: ConfigurationName { configuration(ProjectDeployTarget.stage.rawValue) }
    static var prod: ConfigurationName { configuration(ProjectDeployTarget.prod.rawValue) }
}

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .dev, xcconfig: .shared),
        .debug(name: .stage, xcconfig: .shared),
        .release(name: .prod, xcconfig: .shared),
    ]
}

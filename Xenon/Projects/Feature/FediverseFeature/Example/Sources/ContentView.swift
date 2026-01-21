import SwiftUI
import FediverseFeature

public struct ContentView: View {
    public init() {}
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession

    public var body: some View {
        VStack {
            Spacer()
            Button {
                Task {
                    let url = URL(string: "https://xenon.social")!
                    let result = await SignInManager(
                        webAuthenticationSession: webAuthenticationSession
                    ).signIn(into: url, appInfo: AppInfo.shared)
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            } label: {
                Text("Xenon")
            }
            Button {
                Task {
                    let url = URL(string: "https://haze.social")!
                    let result = await SignInManager(
                        webAuthenticationSession: webAuthenticationSession
                    ).signIn(into: url, appInfo: AppInfo.shared)
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            } label: {
                Text("Haze")
            }
            Image(
                production: .init(systemName: "star"),
                dev: .init(systemName: "pencil"),
                stage: .init(systemName: "trash.circle.fill")
            )
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Image: EnvironmentCompatible {}

public struct AppInfo: AppInfoType {
    
    static let shared = AppInfo()
    public let clientName = "xenon"
    public let scheme = "xenon://"
    public let weblink = "https://xenon.social/@xenon"
    public let defaultServer = "xenon.social"
}

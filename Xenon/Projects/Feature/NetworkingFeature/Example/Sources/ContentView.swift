import SwiftUI
import Alamofire
import NetworkingFeature

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            Text("helloWorld")
            Image(
                production: .init(systemName: "star"),
                dev: .init(systemName: "pencil"),
                stage: .init(systemName: "trash.circle.fill")
            )
            Spacer()
        }.task {
            let result = await NetworkingService().request(api: NodeInfoAPI.get(url: URL(string: "https://haze.social/nodeinfo/2.0")!), dtoType: NodeInfoDTO.self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Image: EnvironmentCompatible {}

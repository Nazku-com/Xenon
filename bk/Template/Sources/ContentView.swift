import SwiftUI

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Image: EnvironmentCompatible {}

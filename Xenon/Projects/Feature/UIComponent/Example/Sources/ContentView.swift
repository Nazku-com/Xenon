import SwiftUI
import UIComponent
import Sugar

public struct ContentView: View {
    public init() {}
    
    @State var path: NavigationPath = .init()
    @State var searchText = ""
    
    public var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: [.init(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                    ForEach(0..<300) { num in
                        ContentCell(
                            content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and",
                            userImageURL: nil,
                            name: "userName",
                            description: "asdf@asdf.com",
                            date: Date(),
                            buttons: [
                                .init(title: "a", image: Image(systemName: "arrowshape.turn.up.backward"), action: {}),
                                .init(title: "b", image: Image(systemName: "arrow.trianglehead.2.clockwise"), action: {}),
                                .init(title: "c", image: Image(systemName: "square.and.arrow.up"), action: {}),
                            ]
                        )
                    }
                }
                .padding(16)
            }
            .background {
                Text("ASDASDASDAS")
                    .font(.system(size: 40, weight: .bold))
            }
            .interactivePushDestination(destination: DestinationView)
        }
    }
    
    @ViewBuilder
    private var DestinationView: some View {
        Text("ASDASA")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.green)
    }
}

extension Image: EnvironmentCompatible {}

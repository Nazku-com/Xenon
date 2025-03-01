import SwiftUI
import FediverseFeature
import EmojiText
import SwiftData
import Kingfisher
import UIComponent

public struct ContentView: View {
    public init() {}
    
    @Environment(\.modelContext) var modelContext
    @Query private var userInfos: [UserInfo]
    
    public var body: some View {
        EmptyView()
    }
}

import SwiftUI
import UIComponent

@main
struct TuistApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserInfo.self)
    }
}

import SwiftUI

@main
struct TuistApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    if GridRowNumerManager.shared.numberOfRows == 0 {
                        GridRowNumerManager.shared.updateNumberOfRows(2)
                    }
                }
        }
    }
}

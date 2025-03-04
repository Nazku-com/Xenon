import SwiftUI

@main
struct TuistApp: App {
    
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
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

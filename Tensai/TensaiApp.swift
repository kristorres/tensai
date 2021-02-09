import SwiftUI

@main
struct TensaiApp: App {
    
    /// The global app state.
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(appState)
        }
    }
}

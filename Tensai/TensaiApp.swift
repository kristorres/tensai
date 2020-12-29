import SwiftUI

@main
struct TensaiApp: App {
    
    /// The view router.
    @StateObject private var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(viewRouter)
        }
    }
}

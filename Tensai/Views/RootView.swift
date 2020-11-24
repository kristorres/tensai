import SwiftUI

/// The **root view** for *Tensai*.
struct RootView: View {
    
    /// The view router.
    @ObservedObject var viewRouter = ViewRouter()
    
    var body: some View {
        switch viewRouter.currentViewKey {
        case .triviaQuizCreator:
            return TriviaQuizCreatorView(viewRouter: viewRouter)
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let viewName = "Root View"
        return Group {
            RootView()
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(viewName) — iPhone SE 1")
            RootView()
                .previewDevice("iPhone X")
                .previewDisplayName("\(viewName) — iPhone X")
            RootView()
                .previewDevice("iPhone X")
                .preferredColorScheme(.dark)
                .previewDisplayName("\(viewName) — iPhone X (Dark Mode)")
            RootView()
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(viewName) — iPad Air 4")
        }
    }
}
#endif

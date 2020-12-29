import SwiftUI

/// The **root view** for *Tensai*.
struct RootView: View {
    
    /// The view router.
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentViewKey {
        case .triviaQuizCreator:
            TriviaQuizCreatorView()
        case .triviaQuiz(let triviaQuiz):
            TriviaQuizView(
                triviaQuizRound: TriviaQuizRound(triviaQuiz: triviaQuiz)
            )
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let viewName = "Root View"
        let view = RootView().environmentObject(ViewRouter())
        return Group {
            view
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(viewName) — iPhone SE 1")
            view
                .previewDevice("iPhone X")
                .previewDisplayName("\(viewName) — iPhone X")
            view
                .previewDevice("iPhone X")
                .preferredColorScheme(.dark)
                .previewDisplayName("\(viewName) — iPhone X (Dark Mode)")
            view
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(viewName) — iPad Air 4")
        }
    }
}
#endif

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
        DevicePreviewGroup(
            name: "Root View",
            view: RootView().environmentObject(ViewRouter())
        )
    }
}
#endif

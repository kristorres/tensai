import SwiftUI

/// The **root view** for *Tensai*.
struct RootView: View {
    
    /// The view router.
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentViewKey {
        case .triviaQuizConfig:
            TriviaQuizConfigView()
        case .triviaQuiz(let viewModel):
            TriviaQuizView(viewModel: viewModel)
                .transition(.move(edge: .trailing))
        case .triviaQuizResult(let viewModel):
            TriviaQuizResultView(viewModel: viewModel)
                .transition(.move(edge: .trailing))
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

import SwiftUI

/// The **root view** for *Tensai*.
struct RootView: View {
    
    /// The global app state.
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            currentView
            if appState.responseIsLoading {
                LoadingView()
            }
        }
            .alert(item: $appState.errorAlert) {
                Alert(title: Text($0.title), message: Text($0.message))
            }
    }
    
    /// The currently rendered view.
    @ViewBuilder private var currentView: some View {
        switch appState.currentViewKey {
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
            view: RootView().environmentObject(AppState())
        )
    }
}
#endif

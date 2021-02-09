import SwiftUI

/// A view to create and start a new trivia quiz.
///
/// The player can select the category, difficulty level, question type, and
/// number of questions in the trivia quiz. The questions are random and
/// retrieved from the *Open Trivia Database*.
struct TriviaQuizConfigView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The global app state.
    @EnvironmentObject private var appState: AppState
    
    /// The settings configuration to retrieve trivia questions from the *Open
    /// Trivia Database*.
    @State private var config = TriviaQuizConfig()
    
    // -------------------------------------------------------------------------
    // MARK:- Other properties
    // -------------------------------------------------------------------------
    
    /// The options for all possible numbers of questions.
    private let questionCountOptions = TriviaQuizConfig.allQuestionCounts
        .map { "\($0) Questions" }
    
    /// The API request loader.
    private let requestLoader = APIRequestLoader<TriviaQuizRequest>(
        apiRequest: TriviaQuizRequest()
    )
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Start a New Quiz")
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.bottom, 12)
            HBarPicker(
                options: TriviaQuizConfig.allCategories,
                selectionIndex: $config.categoryIndex
            )
            HBarPicker(
                options: TriviaQuizConfig.allDifficulties,
                selectionIndex: $config.difficultyIndex
            )
            HBarPicker(
                options: TriviaQuizConfig.allQuestionTypes,
                selectionIndex: $config.questionTypeIndex
            )
            HBarPicker(
                options: questionCountOptions,
                selectionIndex: $config.questionCountIndex
            )
            Spacer()
            CapsuleButton(title: "Play", action: startQuiz)
        }
            .padding()
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private method
    // -------------------------------------------------------------------------
    
    /// Creates and starts a new quiz based on the customization settings.
    private func startQuiz() {
        withAnimation {
            appState.responseIsLoading = true
        }
        requestLoader.loadAPIRequest(requestData: config) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.code == 1 {
                        self.appState.errorAlert = .noResultsErrorAlert
                        return
                    }
                    if response.code == 2 {
                        self.appState.errorAlert = .invalidCategoryErrorAlert
                        return
                    }
                    if response.code > 0 {
                        self.appState.errorAlert = .unknownErrorAlert
                        return
                    }
                    UserDefaults.standard.set(
                        config.propertyList,
                        forKey: LocalStorageKey.triviaQuizConfig
                    )
                    let triviaQuiz = TriviaQuiz(
                        questions: response.questions,
                        decoded: true
                    )
                    withAnimation {
                        self.appState.currentViewKey = .triviaQuiz(
                            TriviaQuizViewModel(triviaQuiz: triviaQuiz)
                        )
                    }
                case .failure(.requestTimedOut):
                    self.appState.errorAlert = .requestTimedOutErrorAlert
                default:
                    self.appState.errorAlert = .unknownErrorAlert
                }
            }
        }
    }
}

#if DEBUG
struct TriviaQuizConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreviewGroup(
            name: "Trivia Quiz Config View",
            view: TriviaQuizConfigView().environmentObject(AppState())
        )
    }
}
#endif

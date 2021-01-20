import SwiftUI

/// A view to create and start a new trivia quiz.
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
        VStack(spacing: 10) {
            Spacer()
            Text("Start a New Quiz").font(.largeTitle).fontWeight(.black)
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
    // MARK:- Private methods
    // -------------------------------------------------------------------------
    
    /// Presents an alert that displays an **Invalid Category** error.
    private func presentInvalidCategoryErrorAlert() {
        appState.errorAlert = ErrorAlert(
            title: "Invalid Category",
            message: "The category is no longer valid. Please try again."
        )
    }
    
    /// Presents an alert that displays a **No Results** error.
    private func presentNoResultsErrorAlert() {
        appState.errorAlert = ErrorAlert(
            title: "Not Enough Questions",
            message: "There are not that many questions in the database to "
                + "start the quiz. Please try again."
        )
    }
    
    /// Presents an alert that displays a **Request Timed Out** error.
    private func presentRequestTimedOutErrorAlert() {
        appState.errorAlert = ErrorAlert(
            title: "Could Not Start the Quiz",
            message: "The request timed out. Please try again."
        )
    }
    
    /// Presents an alert that displays an “unknown error.”
    private func presentUnknownErrorAlert() {
        appState.errorAlert = ErrorAlert(
            title: "Could Not Start the Quiz",
            message: "An unknown error has occurred."
        )
    }
    
    /// Creates and starts a new quiz based on the customization settings.
    private func startQuiz() {
        withAnimation {
            appState.responseIsLoading = true
        }
        requestLoader.loadAPIRequest(requestData: config) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.code == 1 {
                        self.presentNoResultsErrorAlert()
                        return
                    }
                    if response.code == 2 {
                        self.presentInvalidCategoryErrorAlert()
                        return
                    }
                    if response.code > 0 {
                        self.presentUnknownErrorAlert()
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
                }
            case .failure(.requestTimedOut):
                self.presentRequestTimedOutErrorAlert()
            default:
                self.presentUnknownErrorAlert()
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

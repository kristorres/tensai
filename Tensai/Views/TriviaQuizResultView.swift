import SwiftUI

/// A view to see the result of a trivia quiz.
struct TriviaQuizResultView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The view model that binds this view to a quiz of trivia questions.
    @ObservedObject var viewModel: TriviaQuizViewModel
    
    /// The global app state.
    @EnvironmentObject private var appState: AppState
    
    /// Indicates whether the trivia questions are currently presented onscreen.
    @State private var questionsArePresented = false
    
    // -------------------------------------------------------------------------
    // MARK:- Other properties
    // -------------------------------------------------------------------------
    
    /// The minimum value that indicates whether the player passed the trivia
    /// quiz.
    private let passingThreshold = 0.7
    
    /// The API request loader.
    private let requestLoader = APIRequestLoader<TriviaQuizRequest>(
        apiRequest: TriviaQuizRequest()
    )
    
    var body: some View {
        let correctAnswerCount = viewModel.correctAnswerCount
        let questionCount = viewModel.questions.count
        
        return VStack(spacing: 12) {
            Spacer()
            Image(systemName: symbolName)
                .font(.system(size: 160))
                .foregroundColor(scoreColor)
                .padding()
            Text(primaryMessage).font(.largeTitle).fontWeight(.black)
            Text(secondaryMessage).font(.title)
            Text("\(correctAnswerCount)/\(questionCount)")
                .font(.system(size: 64, weight: .heavy))
                .foregroundColor(scoreColor)
            Text("Score: \(viewModel.score)")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
            if !playerPassed {
                CapsuleButton(title: "Retry", action: retryQuiz)
            }
            CapsuleButton(title: "Review Questions", action: reviewQuiz)
                .fullScreenCover(isPresented: $questionsArePresented) {
                    TriviaQuizReviewView(questions: viewModel.questions)
                }
            CapsuleButton(title: "Start a New Quiz", action: goToConfigView)
        }
            .padding()
    }
    
    /// Indicates whether the player passed the trivia quiz.
    private var playerPassed: Bool {
        let correctAnswerCount = Double(viewModel.correctAnswerCount)
        let questionCount = Double(viewModel.questions.count)
        return correctAnswerCount / questionCount >= passingThreshold
    }
    
    /// The primary message.
    private var primaryMessage: String {
        playerPassed ? "Congratulations!" : "Ooh, sorry!"
    }
    
    /// The score color.
    private var scoreColor: Color {
        playerPassed ? .blue : .red
    }
    
    /// The secondary message.
    private var secondaryMessage: String {
        playerPassed ? "You are a true genius!" : "Better luck next time."
    }
    
    /// The SF symbol name.
    private var symbolName: String {
        "\(playerPassed ? "check" : "x")mark.circle.fill"
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private methods
    // -------------------------------------------------------------------------
    
    /// Sends the player back to the *Start a New Quiz* view.
    private func goToConfigView() {
        withAnimation {
            appState.currentViewKey = .triviaQuizConfig
        }
    }
    
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
    
    /// Retries the quiz.
    private func retryQuiz() {
        let localStorage = UserDefaults.standard
        let plist = localStorage.data(forKey: LocalStorageKey.triviaQuizConfig)
        guard let config = TriviaQuizConfig(propertyList: plist) else {
            presentUnknownErrorAlert()
            return
        }
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
    
    /// Reviews the trivia questions.
    private func reviewQuiz() {
        questionsArePresented = true
    }
}

#if DEBUG
struct TriviaQuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        let view = TriviaQuizResultView(
            viewModel: TriviaQuizViewModel(
                triviaQuiz: TriviaQuiz(
                    questions: [
                        OTDQuestion(
                            category: "General Knowledge",
                            type: .multipleChoice,
                            difficulty: .easy,
                            text: "What word represents the letter T in the "
                                + "NATO phonetic alphabet?",
                            correctAnswer: "Tango",
                            incorrectAnswers: [
                                "Target",
                                "Taxi",
                                "Turkey"
                            ]
                        )
                    ]
                )
            )
        )
            .environmentObject(AppState())
        
        return DevicePreviewGroup(name: "Trivia Quiz Result View", view: view)
    }
}
#endif

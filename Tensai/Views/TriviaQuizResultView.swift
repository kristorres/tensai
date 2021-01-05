import SwiftUI

/// A view to see the result of a trivia quiz.
struct TriviaQuizResultView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The round with a quiz of trivia questions.
    @ObservedObject var triviaQuizRound: TriviaQuizRound
    
    /// The view router.
    @EnvironmentObject private var viewRouter: ViewRouter
    
    /// Indicates whether the quiz is loading.
    @State private var quizIsLoading = false
    
    /// The error alert that is currently presented onscreen.
    @State private var errorAlert: ErrorAlert? {
        didSet {
            quizIsLoading = false
        }
    }
    
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
        let correctAnswerCount = triviaQuizRound.correctAnswerCount
        let questionCount = triviaQuizRound.questions.count
        
        return ZStack {
            VStack(spacing: 12) {
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
                Text("Score: \(triviaQuizRound.score)")
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
                if !playerPassed {
                    CapsuleButton(title: "Retry", action: retryQuiz)
                        .alert(item: $errorAlert) { alert in
                            Alert(
                                title: Text(alert.title),
                                message: Text(alert.message)
                            )
                        }
                }
                CapsuleButton(title: "Start a New Quiz", action: goToConfigView)
            }
                .padding()
            
            if quizIsLoading {
                LoadingView()
            }
        }
    }
    
    /// Indicates whether the player passed the trivia quiz.
    private var playerPassed: Bool {
        let correctAnswerCount = Double(triviaQuizRound.correctAnswerCount)
        let questionCount = Double(triviaQuizRound.questions.count)
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
            viewRouter.currentViewKey = .triviaQuizConfig
        }
    }
    
    /// Presents an alert that displays an **Invalid Category** error.
    private func presentInvalidCategoryErrorAlert() {
        errorAlert = ErrorAlert(
            title: "Invalid Category",
            message: "The category is no longer valid. Please try again."
        )
    }
    
    /// Presents an alert that displays a **No Results** error.
    private func presentNoResultsErrorAlert() {
        errorAlert = ErrorAlert(
            title: "Not Enough Questions",
            message: "There are not that many questions in the database to "
                + "start the quiz. Please try again."
        )
    }
    
    /// Presents an alert that displays a **Request Timed Out** error.
    private func presentRequestTimedOutErrorAlert() {
        errorAlert = ErrorAlert(
            title: "Could Not Start the Quiz",
            message: "The request timed out. Please try again."
        )
    }
    
    /// Presents an alert that displays an “unknown error.”
    private func presentUnknownErrorAlert() {
        errorAlert = ErrorAlert(
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
            quizIsLoading = true
        }
        requestLoader.loadAPIRequest(requestData: config) { result in
            switch result {
            case .success(let response):
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
                DispatchQueue.main.async {
                    let triviaQuiz = TriviaQuiz(
                        questions: response.questions,
                        decoded: true
                    )
                    withAnimation {
                        self.viewRouter.currentViewKey = .triviaQuiz(
                            TriviaQuizRound(triviaQuiz: triviaQuiz)
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
    
    // -------------------------------------------------------------------------
    // MARK:- Nested struct
    // -------------------------------------------------------------------------
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The maximum width of a button.
        static let maximumButtonWidth = CGFloat(400)
    }
}

#if DEBUG
struct TriviaQuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        let view = TriviaQuizResultView(
            triviaQuizRound: TriviaQuizRound(
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
            .environmentObject(ViewRouter())
        
        return DevicePreviewGroup(name: "Trivia Quiz Result View", view: view)
    }
}
#endif

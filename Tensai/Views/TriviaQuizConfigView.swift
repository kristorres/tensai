import SwiftUI

/// A view to create and start a new quiz.
struct TriviaQuizConfigView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The view router.
    @EnvironmentObject private var viewRouter: ViewRouter
    
    /// The settings configuration to retrieve trivia questions from the *Open
    /// Trivia Database*.
    @State private var config = TriviaQuizConfig()
    
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
    
    /// The options for all possible numbers of questions.
    private let questionCountOptions = TriviaQuizConfig.allQuestionCounts
        .map { "\($0) Questions" }
    
    /// The API request loader.
    private let requestLoader = APIRequestLoader<TriviaQuizRequest>(
        apiRequest: TriviaQuizRequest()
    )
    
    var body: some View {
        ZStack {
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
                    .alert(item: $errorAlert) {
                        Alert(title: Text($0.title), message: Text($0.message))
                    }
            }
                .padding()
            
            if quizIsLoading {
                LoadingView()
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private methods
    // -------------------------------------------------------------------------
    
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
    
    /// Creates and starts a new quiz based on the customization settings.
    private func startQuiz() {
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
                UserDefaults.standard.set(
                    config.propertyList,
                    forKey: LocalStorageKey.triviaQuizConfig
                )
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
struct TriviaQuizConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreviewGroup(
            name: "Trivia Quiz Config View",
            view: TriviaQuizConfigView().environmentObject(ViewRouter())
        )
    }
}
#endif

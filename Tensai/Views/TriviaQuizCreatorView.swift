import SwiftUI

/// A view to create and start a new quiz.
struct TriviaQuizCreatorView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The view router.
    @EnvironmentObject private var viewRouter: ViewRouter
    
    /// The form to retrieve trivia questions from the *Open Trivia Database*.
    @ObservedObject private var form = TriviaQuizCreatorForm()
    
    /// Indicates whether the quiz is loading.
    @State private var quizIsLoading = false
    
    /// The API response error that is currently presented onscreen.
    @State private var responseError: APIResponseError? {
        didSet {
            quizIsLoading = false
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Other properties
    // -------------------------------------------------------------------------
    
    /// The options for all possible numbers of questions.
    private let questionCountOptions = TriviaQuizCreatorForm.allQuestionCounts
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
                    options: TriviaQuizCreatorForm.allCategories,
                    selectionIndex: $form.categoryIndex
                )
                HBarPicker(
                    options: TriviaQuizCreatorForm.allDifficulties,
                    selectionIndex: $form.difficultyIndex
                )
                HBarPicker(
                    options: TriviaQuizCreatorForm.allQuestionTypes,
                    selectionIndex: $form.questionTypeIndex
                )
                HBarPicker(
                    options: questionCountOptions,
                    selectionIndex: $form.questionCountIndex
                )
                Spacer()
                Button(action: startQuiz) {
                    Text("PLAY")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                        .frame(maxWidth: DrawingConstants.maximumButtonWidth)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                    .alert(item: $responseError) {
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
    
    /// Decodes the specified HTML-encoded question from the *Open Trivia
    /// Database*.
    ///
    /// - Parameter question: The question to be decoded.
    ///
    /// - Returns: The HTML-decoded version of the question.
    private func decodeQuestion(_ question: OTDQuestion) -> OTDQuestion {
        
        let text = question.text.htmlDecodedString ?? question.text
        let correctAnswer = question.correctAnswer.htmlDecodedString
            ?? question.correctAnswer
        let incorrectAnswers = question.incorrectAnswers.map { answer in
            answer.htmlDecodedString ?? answer
        }
        
        return OTDQuestion(
            category: question.category,
            type: question.type,
            difficulty: question.difficulty,
            text: text,
            correctAnswer: correctAnswer,
            incorrectAnswers: incorrectAnswers
        )
    }
    
    /// Creates and starts a new quiz based on the customization settings.
    ///
    /// If the response code from the API request is not `0`, then this method
    /// will show an alert with an appropriate error message instead.
    private func startQuiz() {
        withAnimation {
            quizIsLoading = true
        }
        requestLoader.loadAPIRequest(requestData: form) { result in
            let defaultResponseError = APIResponseError(
                title: "Could Not Start the Quiz",
                message: "An unknown error has occurred."
            )
            switch result {
            case .success(let response):
                if response.code == 1 {
                    self.responseError = APIResponseError(
                        title: "Not Enough Questions",
                        message: "There are not that many questions in the "
                            + "database to start the quiz. Please try again."
                    )
                    return
                }
                if response.code == 2 {
                    self.responseError = APIResponseError(
                        title: "Invalid Category",
                        message: "The category is no longer valid. "
                            + "Please try again."
                    )
                    return
                }
                if response.code > 0 {
                    self.responseError = defaultResponseError
                    return
                }
                DispatchQueue.main.async {
                    let triviaQuiz = TriviaQuiz(
                        questions: response.questions.map(decodeQuestion)
                    )
                    withAnimation {
                        viewRouter.currentViewKey = .triviaQuiz(triviaQuiz)
                    }
                }
            case .failure(.requestTimedOut):
                self.responseError = APIResponseError(
                    title: "Could Not Start the Quiz",
                    message: "The request timed out. Please try again."
                )
            default:
                self.responseError = defaultResponseError
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Nested structs
    // -------------------------------------------------------------------------
    
    /// An internal struct that represents an API response error.
    private struct APIResponseError: Identifiable {
        
        let id = UUID()
        
        /// The title of this API response error.
        let title: String
        
        /// The message of this API response error.
        let message: String
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The maximum width of a button.
        static let maximumButtonWidth = CGFloat(400)
    }
}

fileprivate extension String {
    
    /// The HTML-decoded version of this string.
    ///
    /// ```
    /// let htmlSong = "Twice — <b>&quot;I Can&#8217;t Stop Me&quot;</b>"
    ///
    /// if let song = htmlSong.htmlDecodedString {
    ///     print(song)  // Twice — "I Can’t Stop Me"
    /// }
    /// ```
    ///
    /// - Note: Remember to call this property from the main thread only as it
    ///         uses WebKit to parse HTML underneath.
    var htmlDecodedString: String? {
        if let data = self.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            if let attributedString = try? NSAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            ) {
                return String(attributedString.string)
            }
            return nil
        }
        return nil
    }
}

#if DEBUG
struct TriviaQuizCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreviewGroup(
            name: "Trivia Quiz Creator View",
            view: TriviaQuizCreatorView().environmentObject(ViewRouter())
        )
    }
}
#endif

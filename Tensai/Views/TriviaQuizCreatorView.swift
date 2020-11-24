import SwiftUI

/// A view to create and start a new quiz.
struct TriviaQuizCreatorView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The form to retrieve trivia questions from the *Open Trivia Database*.
    @ObservedObject var form = TriviaQuizCreatorForm()
    
    /// The view router.
    @ObservedObject var viewRouter = ViewRouter()
    
    /// The API response error that is currently presented onscreen.
    @State private var responseError: APIResponseError?
    
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
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private method
    // -------------------------------------------------------------------------
    
    /// Creates and starts a new quiz based on the customization settings.
    ///
    /// If the response code from the API request is not `0`, then this method
    /// will show an alert with an appropriate error message instead.
    private func startQuiz() {
        requestLoader.loadAPIRequest(requestData: form) { (response, error) in
            let defaultResponseError = APIResponseError(
                title: "Could Not Start the Quiz",
                message: "An unknown error has occurred."
            )
            if let response = response {
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
                        message: "The category is no longer valid. " +
                            "Please try again."
                    )
                    return
                }
                if response.code > 0 {
                    self.responseError = defaultResponseError
                    return
                }
                // TODO: Create the quiz!
                DispatchQueue.main.async {
                    // TODO: Start the quiz!
                }
                return
            }
            self.responseError = defaultResponseError
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

#if DEBUG
struct TriviaQuizCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        let viewName = "Trivia Quiz Creator View"
        return Group {
            TriviaQuizCreatorView()
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(viewName) — iPhone SE 1")
            TriviaQuizCreatorView()
                .previewDevice("iPhone X")
                .previewDisplayName("\(viewName) — iPhone X")
            TriviaQuizCreatorView()
                .previewDevice("iPhone X")
                .preferredColorScheme(.dark)
                .previewDisplayName("\(viewName) — iPhone X (Dark Mode)")
            TriviaQuizCreatorView()
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(viewName) — iPad Air 4")
        }
    }
}
#endif

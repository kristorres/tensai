import SwiftUI

/// The global app state.
final class AppState: ObservableObject {
    
    /// The key of the currently rendered view.
    @Published var currentViewKey = ViewKey.triviaQuizConfig {
        didSet {
            responseIsLoading = false
        }
    }
    
    /// Indicates whether an API response is loading.
    @Published var responseIsLoading = false
    
    /// The error alert that is currently presented onscreen.
    @Published var errorAlert: ErrorAlert? {
        didSet {
            responseIsLoading = false
        }
        willSet {
            if newValue != nil {
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.error)
            }
        }
    }
    
    /// A valid key to render a view.
    enum ViewKey {
        
        /// The key to render a view where the user can create and start a new
        /// trivia quiz.
        case triviaQuizConfig
        
        /// The key to render a view where the user answers questions in a
        /// trivia quiz.
        case triviaQuiz(TriviaQuizViewModel)
        
        /// The key to render a view where the user can see the result of a
        /// trivia quiz.
        case triviaQuizResult(TriviaQuizViewModel)
    }
    
    /// An error alert with a title and message.
    struct ErrorAlert: Identifiable {
        
        let id = UUID()
        
        /// The title of the error.
        let title: String
        
        /// The error message.
        let message: String
    }
}

extension AppState.ErrorAlert {
    
    /// An **Invalid Category** error alert.
    static let invalidCategoryErrorAlert = AppState.ErrorAlert(
        title: "Invalid Category",
        message: "The category is no longer valid. Please choose a different "
            + "category and try again."
    )
    
    /// A **No Results** error alert.
    static let noResultsErrorAlert = AppState.ErrorAlert(
        title: "No Results",
        message: "There are not that many questions in the database to start "
            + "the quiz. Please try again with a different query."
    )
    
    /// A **Request Timed Out** error alert.
    static let requestTimedOutErrorAlert = AppState.ErrorAlert(
        title: "Connection Error",
        message: "Please make sure you are connected to a stable network or "
            + "try again later."
    )
    
    /// An **Unknown Error** alert.
    static let unknownErrorAlert = AppState.ErrorAlert(
        title: "Could Not Start the Quiz",
        message: "An unknown error has occurred."
    )
}

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
}

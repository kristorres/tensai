import SwiftUI

/// A router which renders the matched view for the given key.
final class ViewRouter: ObservableObject {
    
    /// The key of the currently rendered view.
    @Published var currentViewKey = Key.triviaQuizConfig
    
    /// A valid key to render a view.
    enum Key {
        
        /// The key to render a view where the user can create and start a new
        /// quiz.
        case triviaQuizConfig
        
        /// The key to render a view where the user answers questions in a
        /// trivia quiz.
        case triviaQuiz(TriviaQuizRound)
        
        /// The key to render a view where the user can see the result of a
        /// trivia quiz.
        case triviaQuizResult(TriviaQuizRound)
    }
}

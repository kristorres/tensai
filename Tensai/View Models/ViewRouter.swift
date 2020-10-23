import SwiftUI

/// A router which renders the matched view for the given key.
final class ViewRouter: ObservableObject {
    
    /// The key of the currently rendered view.
    @Published var currentViewKey = Key.triviaQuizCreator
    
    /// A valid key to render a view.
    enum Key {
        
        /// The key to render a view where the user can create and start a new
        /// quiz.
        case triviaQuizCreator
    }
}

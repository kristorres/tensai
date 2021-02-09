import SwiftUI

/// A view model that binds a view to a quiz of trivia questions.
final class TriviaQuizViewModel: ObservableObject {
    
    // -------------------------------------------------------------------------
    // MARK:- Model
    // -------------------------------------------------------------------------
    
    /// The quiz of trivia questions.
    @Published private var triviaQuiz: TriviaQuiz
    
    // -------------------------------------------------------------------------
    // MARK:- Access to the model
    // -------------------------------------------------------------------------
    
    /// The number of correct answers in the trivia quiz.
    var correctAnswerCount: Int {
        triviaQuiz.correctAnswerCount
    }
    
    /// The number of incorrect answers in the trivia quiz.
    var incorrectAnswerCount: Int {
        triviaQuiz.incorrectAnswerCount
    }
    
    /// The questions in the trivia quiz.
    var questions: [TriviaQuiz.Question] {
        triviaQuiz.questions
    }
    
    /// The player’s score on the trivia quiz.
    var score: Int {
        triviaQuiz.score
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Initializer
    // -------------------------------------------------------------------------
    
    /// Creates a round with the specified quiz of trivia questions.
    ///
    /// - Parameter triviaQuiz: The trivia quiz.
    init(triviaQuiz: TriviaQuiz) {
        self.triviaQuiz = triviaQuiz
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Intent
    // -------------------------------------------------------------------------
    
    /// Submits an answer to the question at the specified index.
    ///
    /// If the player already answered the question, or his/her answer is not
    /// `nil` but invalid, then this method will do nothing.
    ///
    /// - Parameter answer: The player’s answer to the question.
    /// - Parameter index:  The index locating the question in the trivia quiz.
    func submitAnswer(_ answer: String?, at index: Int) {
        triviaQuiz.submitAnswer(answer, at: index)
    }
}

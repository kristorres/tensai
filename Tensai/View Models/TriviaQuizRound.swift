import SwiftUI

/// A round with a quiz of trivia questions.
final class TriviaQuizRound: ObservableObject {
    
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
    
    /// The current question in the trivia quiz.
    var currentQuestion: TriviaQuiz.Question {
        triviaQuiz.currentQuestion
    }
    
    /// The current question number.
    var currentQuestionNumber: Int {
        triviaQuiz.currentQuestionIndex + 1
    }
    
    /// The number of incorrect answers in the trivia quiz.
    var incorrectAnswerCount: Int {
        triviaQuiz.incorrectAnswerCount
    }
    
    /// The number of questions in the trivia quiz.
    var questionCount: Int {
        triviaQuiz.questionCount
    }
    
    /// The player’s score on the trivia quiz.
    var score: Int {
        triviaQuiz.score
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Initializer
    // -------------------------------------------------------------------------
    
    /// Creates a round with a trivia quiz containing the specified questions
    /// from the *Open Trivia Database*.
    ///
    /// - Parameter questions: The questions in the quiz.
    init(questions: [OTDQuestion]) {
        triviaQuiz = TriviaQuiz(questions: questions)
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Intents
    // -------------------------------------------------------------------------
    
    /// Advances to the next question in the trivia quiz.
    func advanceToNextQuestion() {
        triviaQuiz.advanceToNextQuestion()
    }
    
    /// Submits the specified answer to the current question in the trivia quiz.
    ///
    /// - Parameter answer: The player’s answer to the current question.
    func submitAnswer(_ answer: String) {
        triviaQuiz.submitAnswer(answer)
    }
}

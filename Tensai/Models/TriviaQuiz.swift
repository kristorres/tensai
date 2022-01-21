import Foundation

/// A quiz of trivia questions.
struct TriviaQuiz {
    
    // MARK: Initializer
    
    /// Creates a trivia quiz with the given questions from the
    /// [Open Trivia Database](https://opentdb.com).
    ///
    /// - Parameter questions: The questions in the quiz.
    init(questions: [OTDBResponse.Question]) {
        self.questions = questions.map { question in
            var answers = [question.correctAnswer] + question.incorrectAnswers
            answers = (question.type == .multipleChoice)
                ? answers.shuffled()
                : answers.sorted().reversed()
            
            return Question(
                description: question.string,
                category: question.category,
                type: question.type,
                possibleAnswers: answers,
                correctAnswer: question.correctAnswer
            )
        }
    }
    
    // MARK: Stored property
    
    /// The questions in the trivia quiz.
    private(set) var questions: [Question]
    
    // MARK: Computed properties
    
    /// The number of correct answers in the trivia quiz.
    var correctAnswerCount: Int {
        questions.reduce(0) { (sum, question) in
            if !question.isAnswered {
                return sum
            }
            if question.selectedAnswer == question.correctAnswer {
                return sum + 1
            }
            return sum
        }
    }
    
    /// The index of the current question.
    var currentQuestionIndex: Int? {
        questions.firstIndex {
            $0.isActive
        }
    }
    
    // MARK: Methods
    
    /// Marks the current question as done.
    ///
    /// If `currentQuestionIndex` is `nil` or the player has not answered the
    /// question yet, then this method will do nothing.
    ///
    /// - Complexity: O(*n*), where *n* is the number of questions in the trivia
    ///               quiz.
    mutating func markCurrentQuestionAsDone() {
        guard
            let index = currentQuestionIndex,
            questions[index].isAnswered
        else {
            return
        }
        
        questions[index].isActive = false
    }
    
    /// Submits an answer to the current question.
    ///
    /// If `currentQuestionIndex` is `nil` or the player already answered the
    /// question, then this method will do nothing.
    ///
    /// - Complexity: O(*n*), where *n* is the number of questions in the trivia
    ///               quiz.
    ///
    /// - Parameter answer: The player’s answer to the current question.
    mutating func submitAnswer(_ answer: String?) {
        guard
            let index = currentQuestionIndex,
            !questions[index].isAnswered
        else {
            return
        }
        
        questions[index].selectedAnswer = answer
        questions[index].isAnswered = true
    }
    
    // MARK: Nested struct
    
    /// A question in a trivia quiz.
    struct Question: CustomStringConvertible {
        
        /// The textual representation of the question.
        let description: String
        
        /// The category of the question.
        let category: String
        
        /// The question type.
        let type: OTDBResponse.Question.Kind
        
        /// The possible answers to the question.
        let possibleAnswers: [String]
        
        /// The correct answer to the question.
        let correctAnswer: String
        
        /// The player’s selected answer to the question.
        var selectedAnswer: String?
        
        /// Indicates whether the question is answered.
        var isAnswered = false
        
        /// Indicates whether the question is active.
        var isActive = true
    }
}

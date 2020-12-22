import Foundation

/// A quiz of trivia questions.
struct TriviaQuiz {
    
    // -------------------------------------------------------------------------
    // MARK:- Stored properties
    // -------------------------------------------------------------------------
    
    /// The questions in this trivia quiz.
    let questions: [Question]
    
    /// The selected answers in this trivia quiz.
    ///
    /// The index of each answer is the same as that of its corresponding
    /// question.
    private(set) var answers = [String?]()
    
    /// The index of the current question in this trivia quiz.
    private(set) var currentQuestionIndex = 0
    
    // -------------------------------------------------------------------------
    // MARK:- Computed properties
    // -------------------------------------------------------------------------
    
    /// The number of correct answers in this trivia quiz.
    var correctAnswerCount: Int {
        var count = 0
        for index in answers.indices {
            if answers[index] == questions[index].correctAnswer {
                count += 1
            }
        }
        return count
    }
    
    /// The current question in this trivia quiz.
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    /// The number of incorrect answers in this trivia quiz.
    var incorrectAnswerCount: Int {
        answers.count - correctAnswerCount
    }
    
    /// The number of questions in this trivia quiz.
    var questionCount: Int {
        questions.count
    }
    
    /// The player’s score on this trivia quiz.
    var score: Int {
        var pointCount = 0
        for index in answers.indices {
            let question = questions[index]
            if answers[index] == question.correctAnswer {
                switch question.difficulty {
                case .easy: pointCount += 1
                case .medium: pointCount += 2
                case .hard: pointCount += 3
                }
            }
        }
        return pointCount
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Initializer
    // -------------------------------------------------------------------------
    
    /// Creates a trivia quiz with the specified questions from the *Open Trivia
    /// Database*.
    ///
    /// - Parameter questions: The questions in the quiz.
    init(questions: [OTDQuestion]) {
        self.questions = questions.map { question in
            var answers = [question.correctAnswer] + question.incorrectAnswers
            switch question.type {
            case .multipleChoice: answers = answers.shuffled()
            case .trueOrFalse: answers = answers.sorted().reversed()
            }
            return Question(
                category: question.category,
                type: question.type,
                difficulty: question.difficulty,
                text: question.text,
                possibleAnswers: answers,
                correctAnswer: question.correctAnswer
            )
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Methods
    // -------------------------------------------------------------------------
    
    /// Advances to the next question in this trivia quiz, if possible.
    ///
    /// If the player did not answer the current question yet or is already on
    /// the last question, then this method will do nothing.
    mutating func advanceToNextQuestion() {
        if answers.count == currentQuestionIndex {
            return
        }
        if currentQuestionIndex < questionCount - 1 {
            currentQuestionIndex += 1
        }
    }
    
    /// Submits the specified answer to the current question in this trivia
    /// quiz, if possible.
    ///
    /// If the player already answered the question, then this method will do
    /// nothing.
    ///
    /// - Parameter answer: The player’s answer to the current question.
    mutating func submitAnswer(_ answer: String) {
        if answers.count == currentQuestionIndex + 1 {
            return
        }
        answers.append(answer)
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Nested struct
    // -------------------------------------------------------------------------
    
    /// A question in a trivia quiz.
    struct Question {
        
        /// The category of this question.
        let category: String
        
        /// The question type.
        let type: OTDQuestion.Format
        
        /// The difficulty level of this question.
        let difficulty: OTDQuestion.Difficulty
        
        /// The textual representation of this question.
        let text: String
        
        /// The list of all possible answers to this question.
        let possibleAnswers: [String]
        
        /// The correct answer to this question.
        let correctAnswer: String
        
        /// The player’s selected answer to this question.
        var selectedAnswer: String? {
            didSet {
                isAnswered = true
            }
        }
        
        /// Indicates whether this question is answered.
        var isAnswered = false
        
        /// Indicates whether this question is active.
        var isActive = false
    }
}

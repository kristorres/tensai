import Foundation

/// A quiz of trivia questions.
struct TriviaQuiz {
    
    // -------------------------------------------------------------------------
    // MARK:- Stored property
    // -------------------------------------------------------------------------
    
    /// The questions in this trivia quiz.
    private(set) var questions: [Question]
    
    // -------------------------------------------------------------------------
    // MARK:- Computed properties
    // -------------------------------------------------------------------------
    
    /// The number of correct answers in this trivia quiz.
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
    
    /// The number of incorrect answers in this trivia quiz.
    var incorrectAnswerCount: Int {
        questions.reduce(0) { (sum, question) in
            if !question.isAnswered {
                return sum
            }
            if question.selectedAnswer != question.correctAnswer {
                return sum + 1
            }
            return sum
        }
    }
    
    /// The player’s score on this trivia quiz.
    var score: Int {
        questions.reduce(0) { (sum, question) in
            if !question.isAnswered {
                return sum
            }
            if question.selectedAnswer == question.correctAnswer {
                switch question.difficulty {
                case .easy: return sum + 50
                case .medium: return sum + 100
                case .hard: return sum + 150
                }
            }
            return sum
        }
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
    // MARK:- Method
    // -------------------------------------------------------------------------
    
    /// Submits an answer to the question at the specified index.
    ///
    /// If the player already answered the question, or his/her answer is not
    /// `nil` but invalid, then this method will do nothing.
    ///
    /// - Parameter answer: The player’s answer to the question.
    /// - Parameter index:  The index locating the question in this trivia quiz.
    mutating func submitAnswer(_ answer: String?, at index: Int) {
        if questions[index].isAnswered {
            return
        }
        if let answer = answer,
            !questions[index].possibleAnswers.contains(answer) {
            return
        }
        questions[index].selectedAnswer = answer
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
    }
}

extension TriviaQuiz {
    
    /// Creates a trivia quiz with the specified questions from the *Open Trivia
    /// Database*.
    ///
    /// - Parameter questions: The questions in the quiz.
    /// - Parameter decoded:   `true` to decode the questions, or `false`
    ///                        otherwise.
    init(questions: [OTDQuestion], decoded: Bool) {
        if !decoded {
            self.init(questions: questions)
            return
        }
        self.init(questions: questions.map { $0.decoded })
    }
}

extension OTDQuestion {
    
    /// The HTML-decoded version of this question.
    var decoded: OTDQuestion {
        let newText = text.htmlDecodedString ?? text
        let newCorrectAnswer = correctAnswer.htmlDecodedString ?? correctAnswer
        let newIncorrectAnswers = incorrectAnswers.map {
            $0.htmlDecodedString ?? $0
        }
        return OTDQuestion(
            category: category,
            type: type,
            difficulty: difficulty,
            text: newText,
            correctAnswer: newCorrectAnswer,
            incorrectAnswers: newIncorrectAnswers
        )
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
    var htmlDecodedString: String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return nil
        }
        return String(attributedString.string)
    }
}

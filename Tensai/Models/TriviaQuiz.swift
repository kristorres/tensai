import Foundation

/// A quiz of trivia questions.
struct TriviaQuiz {
    
    // MARK: Initializer
    
    /// Creates a trivia quiz with the specified questions from the *Open Trivia
    /// Database*.
    ///
    /// - Parameter questions: The questions in the quiz.
    init(questions: [OpenTriviaDB.Question]) {
        self.questions = questions.map { question in
            let description = question.description.htmlDecoded
                ?? question.description
            let correctAnswer = question.correctAnswer.htmlDecoded
                ?? question.correctAnswer
            let incorrectAnswers = question.incorrectAnswers.map {
                $0.htmlDecoded ?? $0
            }
            
            var answers = [correctAnswer] + incorrectAnswers
            switch question.type {
            case .multipleChoice: answers = answers.shuffled()
            case .trueOrFalse: answers = answers.sorted().reversed()
            }
            
            return Question(
                category: question.category,
                type: question.type,
                difficulty: question.difficulty,
                description: description,
                possibleAnswers: answers,
                correctAnswer: correctAnswer
            )
        }
    }
    
    // MARK: Stored property
    
    /// The questions in this trivia quiz.
    private(set) var questions: [Question]
    
    // MARK: Computed property
    
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
    
    // MARK: Method
    
    /// Submits an answer to the question at the specified index.
    ///
    /// If the player already answered the question, then this method will do
    /// nothing.
    ///
    /// - Parameter answer: The player’s answer to the question.
    /// - Parameter index:  The index locating the question in this trivia quiz.
    mutating func submitAnswer(_ answer: String?, at index: Int) {
        if questions[index].isAnswered {
            return
        }
        questions[index].selectedAnswer = answer
        questions[index].isAnswered = true
    }
    
    // MARK: Nested struct
    
    /// A question in a trivia quiz.
    struct Question: CustomStringConvertible {
        
        /// The category of this question.
        let category: String
        
        /// The question type.
        let type: OpenTriviaDB.Question.Kind
        
        /// The difficulty level of this question.
        let difficulty: OpenTriviaDB.Question.Difficulty
        
        /// The textual representation of this question.
        let description: String
        
        /// The possible answers to this question.
        let possibleAnswers: [String]
        
        /// The correct answer to this question.
        let correctAnswer: String
        
        /// The player’s selected answer to this question.
        var selectedAnswer: String?
        
        /// Indicates whether this question is answered.
        var isAnswered = false
    }
}

fileprivate extension String {
    
    /// The HTML-decoded version of this string.
    ///
    /// ```
    /// let htmlSong = "Twice — <b>&quot;I Can&#8217;t Stop Me&quot;</b>"
    ///
    /// if let song = htmlSong.htmlDecoded {
    ///     print(song)  // Twice — "I Can’t Stop Me"
    /// }
    /// ```
    var htmlDecoded: String? {
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

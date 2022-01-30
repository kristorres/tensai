import Foundation

/// A response from an API call to fetch trivia questions from the
/// [Open Trivia Database](https://opentdb.com).
///
/// We usually decode the response using a `JSONDecoder`.
struct OTDBResponse: Codable {
    
    /// The response code.
    let code: Int
    
    /// The fetched trivia questions.
    let questions: [Question]
    
    /// A trivia question in the [Open Trivia Database](https://opentdb.com).
    struct Question: Codable {
        
        /// Creates a trivia question with the given arguments.
        ///
        /// The `string`, `correctAnswer`, and `incorrectAnswers` arguments will
        /// be HTML-decoded, if possible.
        ///
        /// - Parameter string:           The string for the question.
        /// - Parameter category:         The category.
        /// - Parameter difficulty:       The difficulty level.
        /// - Parameter type:             The question type.
        /// - Parameter correctAnswer:    The correct answer.
        /// - Parameter incorrectAnswers: The possible incorrect answers.
        init(
            _ string: String,
            category: String,
            difficulty: Difficulty,
            type: Kind,
            correctAnswer: String,
            incorrectAnswers: [String]
        ) {
            self.string = string.htmlDecoded ?? string
            self.category = category
            self.difficulty = difficulty
            self.type = type
            self.correctAnswer = correctAnswer.htmlDecoded ?? correctAnswer
            self.incorrectAnswers = incorrectAnswers.map {
                $0.htmlDecoded ?? $0
            }
        }
        
        /// Creates a trivia question by decoding from the given decoder.
        ///
        /// - Parameter decoder: The decoder to read data from.
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            let string = try values.decode(String.self, forKey: .string)
            let category = try values.decode(String.self, forKey: .category)
            let difficulty = try values
                .decode(Difficulty.self, forKey: .difficulty)
            let type = try values.decode(Kind.self, forKey: .type)
            let correctAnswer = try values
                .decode(String.self, forKey: .correctAnswer)
            let incorrectAnswers = try values
                .decode([String].self, forKey: .incorrectAnswers)
            
            self.init(
                string,
                category: category,
                difficulty: difficulty,
                type: type,
                correctAnswer: correctAnswer,
                incorrectAnswers: incorrectAnswers
            )
        }
        
        /// The category of the question.
        let category: String
        
        /// The question type.
        let type: Kind
        
        /// The difficulty level of the question.
        let difficulty: Difficulty
        
        /// The question as a string.
        let string: String
        
        /// The correct answer to the question.
        let correctAnswer: String
        
        /// The possible incorrect answers to the question.
        let incorrectAnswers: [String]
        
        /// A question’s difficulty level.
        enum Difficulty: String, Codable {
            
            /// A value indicating that the question is easy.
            case easy
            
            /// A value indicating that the question is of medium difficulty.
            case medium
            
            /// A value indicating that the question is hard.
            case hard
        }
        
        /// A question type.
        enum Kind: String, Codable {
            
            /// A value indicating that the question is multiple-choice
            /// (traditionally, with 4 possible answers).
            case multipleChoice = "multiple"
            
            /// A value indicating that the question is true-or-false.
            case trueOrFalse = "boolean"
        }
        
        private enum CodingKeys: String, CodingKey {
            case category
            case type
            case difficulty
            case string = "question"
            case correctAnswer = "correct_answer"
            case incorrectAnswers = "incorrect_answers"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case code = "response_code"
        case questions = "results"
    }
}

import Foundation

/// The [*Open Trivia Database*](https://opentdb.com) namespace.
struct OpenTriviaDB {
    
    /// A question in the *Open Trivia Database*.
    struct Question: Codable, CustomStringConvertible {
        
        /// The category of this question.
        let category: String
        
        /// The question type.
        let type: Kind
        
        /// The difficulty level of this question.
        let difficulty: Difficulty
        
        /// The textual representation of this question.
        let description: String
        
        /// The correct answer to this question.
        let correctAnswer: String
        
        /// The possible incorrect answers to this question.
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
            case description = "question"
            case correctAnswer = "correct_answer"
            case incorrectAnswers = "incorrect_answers"
        }
    }
}

import Foundation

/// A question in the *Open Trivia Database*.
struct Question: Codable {
    
    // -------------------------------------------------------------------------
    // MARK:- Stored properties
    // -------------------------------------------------------------------------
    
    /// The category of this question.
    let category: String
    
    /// The question type.
    let type: Format
    
    /// The difficulty level of this question.
    let difficulty: Difficulty
    
    /// The textual representation of this question.
    let text: String
    
    /// The correct answer to this question.
    let correctAnswer: String
    
    /// The list of incorrect answers to this question.
    let incorrectAnswers: [String]
    
    // -------------------------------------------------------------------------
    // MARK:- Nested enums
    // -------------------------------------------------------------------------
    
    /// An internal type that represents a question’s difficulty level.
    enum Difficulty: String, Codable {
        
        /// A value indicating that the question is easy.
        case easy
        
        /// A value indicating that the question is of medium difficulty.
        case medium
        
        /// A value indicating that the question is hard.
        case hard
    }
    
    /// An internal type that represents a format for the list of possible
    /// answers to a question.
    enum Format: String, Codable {
        
        /// A value indicating that the question is multiple-choice
        /// (traditionally, with 4 possible answers).
        case multipleChoice = "multiple"
        
        /// A value indicating that the question is true-or-false.
        case trueOrFalse = "boolean"
    }
    
    /// An internal type that contains the keys for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case category
        case type
        case difficulty
        case text = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

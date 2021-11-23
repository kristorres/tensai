import Foundation

/// A response from an API call to the
/// [Open Trivia Database](https://opentdb.com).
struct OTDBResponse: Codable {
    
    /// The response code.
    let code: Int
    
    /// The questions.
    let questions: [OpenTriviaDB.Question]
    
    /// An internal type that contains the keys for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case code = "response_code"
        case questions = "results"
    }
}

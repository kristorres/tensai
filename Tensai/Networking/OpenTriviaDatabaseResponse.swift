import Foundation

/// A response from an API call to the *Open Trivia Database*.
struct OpenTriviaDatabaseResponse: Codable {
    
    /// The response code.
    let code: Int
    
    /// The questions.
    let questions: [OTDQuestion]
    
    /// An internal type that contains the keys for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case code = "response_code"
        case questions = "results"
    }
}

import Foundation

/// A request to retrieve trivia questions from the *Open Trivia Database*.
struct TriviaQuizRequest: APIRequest {
    
    func makeRequest(from config: TriviaQuizConfig) -> URLRequest {
        return URLRequest(url: config.apiURL!)
    }
    
    func parseResponse(data: Data) throws -> OpenTriviaDatabaseResponse {
        return try JSONDecoder().decode(
            OpenTriviaDatabaseResponse.self,
            from: data
        )
    }
}

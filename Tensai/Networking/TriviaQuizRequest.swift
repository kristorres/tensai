import Foundation

/// A request to retrieve trivia questions from the *Open Trivia Database*.
struct TriviaQuizRequest: APIRequest {
    
    func makeRequest(from data: TriviaQuizCreatorForm) -> URLRequest {
        return URLRequest(url: data.apiURL!)
    }
    
    func parseResponse(data: Data) throws -> OpenTriviaDatabaseResponse {
        return try JSONDecoder().decode(
            OpenTriviaDatabaseResponse.self,
            from: data
        )
    }
}

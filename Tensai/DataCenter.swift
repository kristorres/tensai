import Foundation

/// An object that handles data fetching.
final class DataCenter {
    
    /// Creates a data center with the given URL session.
    ///
    /// - Parameter urlSession: The URL session. The default is a session that
    ///                         is configured with no caching policy.
    init(urlSession: URLSession = URLSession(configuration: .noCaching)) {
        self.urlSession = urlSession
    }
    
    /// The shared singleton data center.
    static let shared = DataCenter()
    
    /// The URL session.
    private let urlSession: URLSession
    
    /// Creates a new trivia quiz with the given query to the
    /// [Open Trivia Database](https://opentdb.com).
    ///
    /// - Parameter query: The database query.
    ///
    /// - Returns: The trivia quiz.
    func createTriviaQuiz(
        with query: OpenTriviaDB.Query
    ) async throws -> TriviaQuiz {
        if query.questionCount <= 0 {
            throw APIError.invalidQuestionCount
        }
        
        let request = URLRequest(url: query.url!)
        return try await makeAPICall(
            with: request,
            processResponse: { (response: OTDBResponse) in
                if response.code == 1 {
                    throw APIError.notEnoughQuestions
                }
                if response.code > 0 {
                    throw APIError.unknown
                }
                
                return TriviaQuiz(questions: response.questions)
            }
        )
    }
    
    /// Makes an API call with the given URL request.
    ///
    /// - Parameter request:         The URL request.
    /// - Parameter processResponse: The closure to process the raw API response
    ///                              body.
    ///
    /// - Returns: The final output returned from `processResponse`.
    private func makeAPICall<APIResponse: Codable, Output>(
        with request: URLRequest,
        processResponse: (APIResponse) throws -> Output
    ) async throws -> Output {
        do {
            let (data, _) = try await urlSession.data(for: request)
            let response = try JSONDecoder().decode(
                APIResponse.self,
                from: data
            )
            return try processResponse(response)
        }
        catch let error as APIError {
            throw error
        }
        catch is DecodingError {
            throw APIError.cannotParseResponse
        }
        catch let error as NSError where error.code == NSURLErrorTimedOut {
            throw APIError.requestTimedOut
        }
        catch {
            throw APIError.unknown
        }
    }
    
    /// An error from an API call.
    enum APIError: Error {
        
        /// An API error which indicates an invalid number of questions in a
        /// trivia quiz.
        case invalidQuestionCount
        
        /// An API error which indicates that there are not enough questions
        /// from a given query.
        case notEnoughQuestions
        
        /// An API error which indicates a response that could not be parsed.
        case cannotParseResponse
        
        /// An API error which indicates a request that timed out.
        case requestTimedOut
        
        /// An unknown API error.
        case unknown
    }
}

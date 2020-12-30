import Foundation

/// A type that represents a network error.
enum NetworkError: Error {
    
    /// A network error which indicates a bad request.
    case badRequest
    
    /// A network error which indicates a response that could not be parsed.
    case cannotParseResponse
    
    /// A network error which indicates a request that failed.
    case requestFailed
    
    /// A network error which indicates a request that timed out.
    case requestTimedOut
    
    /// An unknown network error.
    case unknown
}

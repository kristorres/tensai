import Foundation

/// A type that represents a network error.
enum NetworkError: Error {
    
    /// A network error that indicates a bad request.
    case badRequest
    
    /// A network error that indicates a failed request.
    case requestFailed
    
    /// A network error that indicates a timed-out request.
    case requestTimeout
    
    /// A network error that indicates a failure in parsing the HTTP response.
    case responseParsingFailed
    
    /// A network error that indicates an unknown error.
    case unknown
}

import Foundation

/// A type representing an API request.
protocol APIRequest {
    
    /// The data type of a request.
    associatedtype RequestDataType
    
    /// The data type of a response.
    associatedtype ResponseDataType
    
    /// Creates a URL request from the specified data.
    ///
    /// - Parameter data: The request data to encode.
    ///
    /// - Returns: The URL request.
    func makeRequest(from data: RequestDataType) throws -> URLRequest
    
    /// Parses a response from the specified data.
    ///
    /// - Parameter data: The data to decode.
    ///
    /// - Returns: The response.
    func parseResponse(data: Data) throws -> ResponseDataType
}

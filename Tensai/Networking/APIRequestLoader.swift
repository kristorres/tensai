import Foundation

/// An instance that loads an API request.
struct APIRequestLoader<T> where T: APIRequest {
    
    /// The API request.
    private var apiRequest: T
    
    /// The URL session.
    private var urlSession: URLSession
    
    /// Creates a loader with the specified API request and URL session.
    ///
    /// - Parameter apiRequest: The API request.
    /// - Parameter urlSession: The URL session. The default is a session that
    ///                         is configured with no caching policy.
    init(
        apiRequest: T,
        urlSession: URLSession = URLSession(configuration: .noCaching)
    ) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    /// Loads an API request with the specified data.
    ///
    /// - Parameter requestData:       The request data.
    /// - Parameter completionHandler: The completion handler to execute.
    func loadAPIRequest(
        requestData: T.RequestDataType,
        completionHandler: @escaping (Result<T.ResponseDataType, NetworkError>) -> Void
    ) {
        guard let urlRequest = try? apiRequest.makeRequest(
            from: requestData
        ) else {
            return completionHandler(.failure(.badRequest))
        }
        
        let task = urlSession.dataTask(with: urlRequest) { (data, _, error) in
            if let data = data {
                if let parsedResponse = try? self.apiRequest.parseResponse(
                    data: data
                ) {
                    return completionHandler(.success(parsedResponse))
                }
                return completionHandler(.failure(.cannotParseResponse))
            }
            if let error = error {
                let errorCode = (error as NSError).code
                if errorCode == NSURLErrorTimedOut {
                    return completionHandler(.failure(.requestTimedOut))
                }
                return completionHandler(.failure(.requestFailed))
            }
            completionHandler(.failure(.unknown))
        }
        task.resume()
    }
}

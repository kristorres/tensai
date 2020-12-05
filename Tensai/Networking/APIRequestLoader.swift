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
        completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void
    ) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data else {
                    return completionHandler(nil, error)
                }
                do {
                    let parsedResponse = try self.apiRequest.parseResponse(
                        data: data
                    )
                    completionHandler(parsedResponse, nil)
                }
                catch {
                    completionHandler(nil, error)
                }
            }.resume()
        }
        catch {
            return completionHandler(nil, error)
        }
    }
}

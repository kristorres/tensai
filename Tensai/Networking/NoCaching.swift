import Foundation

extension URLSessionConfiguration {
    
    /// A session configuration that has no caching policy.
    static var noCaching: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        return configuration
    }
}

import Foundation

extension URLSessionConfiguration {
    
    /// A session configuration that has no caching policy.
    ///
    /// This session configuration also waits at most 1 minute for a response
    /// before timing out.
    static var noCaching: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 60
        return configuration
    }
}

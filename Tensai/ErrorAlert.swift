import Foundation

/// An error alert with a title and message.
struct ErrorAlert: Identifiable {
    
    let id = UUID()
    
    /// The title of the error.
    let title: String
    
    /// The error message.
    let message: String
}

import SwiftUI

/// The global app theme.
///
/// The purpose of the theme is to apply a consistent tone to the app. You can
/// customize design aspects such as the colors, typography, and more.
struct AppTheme {
    
    /// A main/content pair color.
    typealias ColorPair = (mainColor: Color, contentColor: Color)
    
    /// The color palette.
    struct ColorPalette {
        static let primary = colorPair(name: "Primary")
        static let secondary = colorPair(name: "Secondary")
        static let danger = colorPair(name: "Danger")
        static let surface = colorPair(name: "Surface")
        static let background = colorPair(name: "Background")
        
        /// Returns a color pair from the color resource with the specified
        /// name.
        ///
        /// - Parameter name: The name of the color resource.
        ///
        /// - Returns:
        ///   - mainColor:    The main color.
        ///   - contentColor: The color of elements that appear “on” top of
        ///                   components with a `mainColor` fill.
        private static func colorPair(name: String) -> ColorPair {
            return (Color(name), Color("On \(name)"))
        }
    }
}

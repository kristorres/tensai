import SwiftUI

/// A main/content color pair.
typealias MCColorPair = (main: Color, content: Color)

/// An app theme.
///
/// The purpose of the theme is to apply a consistent tone to the app. You can
/// customize design aspects such as the colors, typography, and more.
///
/// The conventional way to create a new theme from an already existing theme is
/// to extend the `UrbanTheme` type and customize any of the properties.
///
/// ```
/// extension UrbanTheme {
///     static let sana: UrbanTheme = {
///         var theme = UrbanTheme()
///         theme.palette.primary.main = .pink
///         theme.palette.secondary.main = .purple
///         // …
///
///         return theme
///     }()
/// }
/// ```
///
/// You can then use an environment value to dynamically control the theme of a
/// SwiftUI view (and its children).
///
/// ```
/// // Setting the theme
/// MyView().environment(\.theme, .sana)
///
/// // Getting the theme
/// @Environment(\.theme) private var theme
/// ```
struct UrbanTheme {
    
    /// Creates a default app theme.
    init() {}
    
    /// The color palette.
    var palette = Palette()
    
    /// The standard shadow “radius.”
    var shadowRadius: CGFloat = 4
    
    /// A color palette.
    struct Palette {
        
        /// Creates a default color palette.
        init() {}
        
        /// The main/content color pair used most frequently across the app.
        var primary: MCColorPair = (
            .torresBlue,
            .dynamic(light: .white, dark: .black)
        )
        
        /// The main/content color pair used to accent and distinguish the app.
        var secondary: MCColorPair = (.torresGold, .black)
        
        /// The main/content color pair used to indicate warnings, errors, or
        /// other destructive actions.
        var danger: MCColorPair = (
            .dynamic(
                light: Color(red: 0.7961, green: 0.2039, blue: 0.098),
                dark: Color(red: 0.8784, green: 0.5216, blue: 0.4588)
            ),
            .dynamic(light: .white, dark: .black)
        )
        
        /// The main/content color pair used on surface components, such as
        /// cards, sheets, and menus.
        var surface: MCColorPair = (
            .dynamic(
                light: .white,
                dark: Color(red: 0.149, green: 0.1961, blue: 0.2196)
            ),
            .dynamic(light: .black, dark: .white)
        )
        
        /// The main/content color pair used on screen backgrounds.
        var background: MCColorPair = (
            .dynamic(
                light: Color(red: 0.9255, green: 0.9373, blue: 0.9451),
                dark: .black
            ),
            .dynamic(light: .black, dark: .white)
        )
        
        /// The main/content color pair used on disabled controls.
        var disabled: MCColorPair = (
            .dynamic(
                light: Color.black.opacity(0.125),
                dark: Color.white.opacity(0.125)
            ),
            .dynamic(
                light: Color.black.opacity(0.375),
                dark: Color.white.opacity(0.375)
            )
        )
    }
}

extension EnvironmentValues {
    
    /// The app theme.
    var theme: UrbanTheme {
        get {
            self[UrbanThemeKey.self]
        }
        set {
            self[UrbanThemeKey.self] = newValue
        }
    }
    
    private struct UrbanThemeKey: EnvironmentKey {
        static let defaultValue = UrbanTheme()
    }
}

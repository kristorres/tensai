import SwiftUI

/// An app theme.
///
/// The purpose of the theme is to apply a consistent tone to the app. You can
/// customize design aspects such as the colors, typography, and more.
///
/// You can use an environment value to dynamically control the theme of a
/// SwiftUI view (and its children).
///
/// ```
/// // Setting the theme
/// MyView().environment(\.theme, .trebek)
///
/// // Getting the theme
/// @Environment(\.theme) private var theme
/// ```
///
/// You can also create a new theme from an already existing theme by
/// customizing any of the properties.
///
/// ```
/// var theme = UrbanTheme.trebek
/// theme.palette = UrbanPalette(name: "Sajak")
/// ```
struct UrbanTheme {
    
    /// The Trebek theme.
    static let trebek = UrbanTheme(
        palette: UrbanPalette(name: "Trebek"),
        shadowRadius: 4
    )
    
    /// The color palette.
    var palette: UrbanPalette
    
    /// The standard shadow “radius.”
    var shadowRadius: CGFloat
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
        static let defaultValue = UrbanTheme.trebek
    }
}

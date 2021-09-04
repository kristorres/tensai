import SwiftUI

/// An app theme.
///
/// The purpose of the theme is to apply a consistent tone to the app. You can
/// customize design aspects such as the colors, typography, and more.
struct AppTheme {
    
    /// The Sana theme.
    static let sana = AppTheme(
        colorPalette: Color.Palette(name: "Sana"),
        shadowRadius: 4
    )
    
    /// The color palette.
    var colorPalette: Color.Palette
    
    /// The standard shadow “radius.”
    var shadowRadius: CGFloat
}

extension EnvironmentValues {
    
    /// The app theme.
    var theme: AppTheme {
        get {
            self[AppThemeKey.self]
        }
        set {
            self[AppThemeKey.self] = newValue
        }
    }
    
    /// A key for accessing the app theme.
    private struct AppThemeKey: EnvironmentKey {
        static let defaultValue = AppTheme.sana
    }
}

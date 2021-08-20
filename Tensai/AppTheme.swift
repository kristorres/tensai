import SwiftUI

/// The global app theme.
///
/// The purpose of the theme is to apply a consistent tone to the app. You can
/// customize design aspects such as the colors, typography, and more.
struct AppTheme {
    
    /// A main/content color pair.
    typealias ColorPair = (mainColor: Color, contentColor: Color)
    
    /// The color palette.
    struct ColorPalette {
        static let primary = colorPair(name: "Primary")
        static let secondary = colorPair(name: "Secondary")
        static let danger = colorPair(name: "Danger")
        static let surface = colorPair(name: "Surface")
        static let background = colorPair(name: "Background")
        static let disabled = colorPair(name: "Disabled")
        
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
    
    /// A button type.
    enum ButtonType {
        
        /// A button type that displays a container with a solid color fill
        /// around a content label.
        case filled
        
        /// A button type that displays a stroke around a content label.
        case outlined
        
        /// A button type that does not decorate its content.
        case plain
    }
    
    /// A color mode that makes sense for the component it is used on.
    enum ColorMode {
        case primary
        case secondary
        case danger
        
        /// The color pair that is associated with this color mode.
        var colorPair: ColorPair {
            switch self {
            case .primary: return ColorPalette.primary
            case .secondary: return ColorPalette.secondary
            case .danger: return ColorPalette.danger
            }
        }
    }
    
    /// Returns a button with the specified title, type, color mode, and action.
    ///
    /// - Parameter title:     The title that is displayed on the button.
    /// - Parameter type:      The button type. The default is `.plain`.
    /// - Parameter colorMode: The color mode that makes sense for the button’s
    ///                        context. The default is `.primary`.
    /// - Parameter action:    The action to perform when a user taps on the
    ///                        button.
    static func button(
        _ title: String,
        type: AppTheme.ButtonType = .plain,
        colorMode: AppTheme.ColorMode = .primary,
        action: @escaping () -> Void
    ) -> some View {
        return SanaButton(
            title,
            type: type,
            colorMode: colorMode,
            action: action
        )
    }
}

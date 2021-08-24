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
    
    /// A button that represents an action in responding to a dialog.
    struct DialogButton {
        
        /// The title that is displayed on this button.
        let title: String
        
        /// The action to perform when a user taps on this button.
        let action: () -> Void
        
        /// Creates a dialog button with the specified title and action.
        ///
        /// - Parameter title:  The title that is displayed on the button.
        /// - Parameter action: The action to perform when a user taps on the
        ///                     button.
        init(_ title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
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
    
    // -------------------------------------------------------------------------
    // MARK:- Components
    // -------------------------------------------------------------------------
    
    /// Returns a button with the specified title, type, color mode, and action.
    ///
    /// - Parameter title:     The title that is displayed on the button.
    /// - Parameter type:      The button type. The default is `.plain`.
    /// - Parameter colorMode: The color mode that makes sense for the button’s
    ///                        context. The default is `.primary`.
    /// - Parameter action:    The action to perform when a user taps on the
    ///                        button.
    ///
    /// - Returns: The button.
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
    
    /// Returns a card with the specified content.
    ///
    /// - Parameter content: The closure to render the content of this card.
    ///
    /// - Returns: The card.
    static func card<Content: View>(
        content: @escaping () -> Content
    ) -> some View {
        return SanaCard(content: content)
    }
    
    /// Returns a dialog with the specified title, content, and action buttons.
    ///
    /// - Parameter title:           The title of the dialog.
    /// - Parameter content:         The closure to render the content of the
    ///                              dialog.
    /// - Parameter primaryButton:   The primary action button.
    /// - Parameter secondaryButton: The secondary action button. The default is
    ///                              `nil`.
    static func dialog<Content: View>(
        title: String,
        content: @escaping () -> Content,
        primaryButton: DialogButton,
        secondaryButton: DialogButton? = nil
    ) -> some View {
        return SanaDialog(
            title: title,
            content: content,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton
        )
    }
    
    /// Returns a picker with a set of possible options.
    ///
    /// - Parameter options:     The possible options.
    /// - Parameter selection:   A binding to the currently selected option.
    /// - Parameter optionLabel: The closure to map an option to its
    ///                          corresponding string label.
    ///
    /// - Returns: The picker.
    static func picker<SelectionValue: Hashable>(
        options: [SelectionValue],
        selection: Binding<SelectionValue>,
        optionLabel: @escaping (SelectionValue) -> String = { "\($0)" }
    ) -> some View {
        return SanaPicker<SelectionValue>(
            options: options,
            selection: selection,
            optionLabel: optionLabel
        )
    }
}

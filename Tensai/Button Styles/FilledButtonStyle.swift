import SwiftUI

/// A button style that displays a container with a solid color fill around a
/// content label.
struct FilledButtonStyle: ButtonStyle {
    
    /// The color pair used on the button.
    private let colorPair: AppTheme.ColorPair
    
    /// Creates a button style with a solid color fill.
    ///
    /// - Parameter colorMode: The color mode of the button. The default is
    ///                        `.primary`.
    init(colorMode: AppTheme.ColorMode = .primary) {
        switch colorMode {
        case .primary: colorPair = AppTheme.ColorPalette.primary
        case .secondary: colorPair = AppTheme.ColorPalette.secondary
        case .danger: colorPair = AppTheme.ColorPalette.danger
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return ContainerView(
            defaultColorPair: colorPair,
            configuration: configuration
        )
    }
    
    /// A container view for this button style.
    private struct ContainerView: View {
        
        /// The default color pair used on the button.
        let defaultColorPair: AppTheme.ColorPair
        
        /// The properties of the button.
        let configuration: Configuration
        
        /// The shape of the button.
        private static let buttonShape = RoundedRectangle(
            cornerRadius: DrawingConstants.cornerRadius
        )
        
        /// Indicates whether the button allows user interaction.
        @Environment(\.isEnabled) private var buttonIsEnabled
        
        var body: some View {
            configuration.label
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .foregroundColor(colorPair.contentColor)
                .padding(.vertical, DrawingConstants.verticalPadding)
                .padding(.horizontal, DrawingConstants.horizontalPadding)
                .background(
                    ZStack {
                        Self.buttonShape
                            .fill(colorPair.mainColor)
                            .shadow(radius: shadowRadius)
                        if configuration.isPressed {
                            Self.buttonShape
                                .fill(DrawingConstants.highlightColor)
                        }
                    }
                )
                .animation(.default, value: buttonIsEnabled)
        }
        
        /// The current color pair used on the button.
        private var colorPair: AppTheme.ColorPair {
            if !buttonIsEnabled {
                return AppTheme.ColorPalette.disabled
            }
            return defaultColorPair
        }
        
        /// The current “radius” of the button’s shadow.
        private var shadowRadius: CGFloat {
            if !buttonIsEnabled {
                return 0
            }
            if configuration.isPressed {
                return DrawingConstants.shadowRadiusWhenButtonIsPressed
            }
            return DrawingConstants.defaultShadowRadius
        }
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The corner radius of the button.
        static let cornerRadius: CGFloat = 16
        
        /// The default “radius” of the button’s shadow.
        static let defaultShadowRadius: CGFloat = 4
        
        /// The highlight color of the button when it is pressed.
        static let highlightColor = Color.white.opacity(lighteningFactor)
        
        /// The horizontal padding in the button.
        static let horizontalPadding = verticalPadding * 2
        
        /// The “radius” of the button’s shadow when the button is pressed.
        static let shadowRadiusWhenButtonIsPressed = defaultShadowRadius * 2
        
        /// The vertical padding in the button.
        static let verticalPadding: CGFloat = 16
        
        /// The scale factor for lightening the background color of the button
        /// when it is pressed.
        private static let lighteningFactor = 0.25
    }
}

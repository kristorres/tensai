import SwiftUI

/// A button style that does not decorate its content when idle.
struct SimpleButtonStyle: ButtonStyle {
    
    /// The button color.
    private let color: Color
    
    /// Creates a button style with no decoration.
    ///
    /// - Parameter colorMode: The color mode of the button. The default is
    ///                        `.primary`.
    init(colorMode: AppTheme.ColorMode = .primary) {
        color = colorMode.colorPair.mainColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return ContainerView(defaultColor: color, configuration: configuration)
    }
    
    /// A container view for this button style.
    private struct ContainerView: View {
        
        /// The default button color.
        let defaultColor: Color
        
        /// The properties of the button.
        let configuration: Configuration
        
        /// Indicates whether the button allows user interaction.
        @Environment(\.isEnabled) private var buttonIsEnabled
        
        var body: some View {
            configuration.label
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .foregroundColor(color)
                .padding(DrawingConstants.padding)
                .background(
                    RoundedRectangle(
                        cornerRadius: DrawingConstants.cornerRadius
                    )
                        .fill(color.opacity(opacity))
                )
                .animation(.default, value: buttonIsEnabled)
        }
        
        /// The current button color.
        private var color: Color {
            if !buttonIsEnabled {
                return AppTheme.ColorPalette.disabled.contentColor
            }
            return defaultColor
        }
        
        /// The current opacity of the button.
        private var opacity: Double {
            if !buttonIsEnabled {
                return 0
            }
            if configuration.isPressed {
                return DrawingConstants.opacityWhenButtonIsPressed
            }
            return 0
        }
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The corner radius of the button.
        static let cornerRadius: CGFloat = 16
        
        /// The opacity of the button when it is pressed.
        static let opacityWhenButtonIsPressed = 0.25
        
        /// The padding in the button.
        static let padding: CGFloat = 16
    }
}

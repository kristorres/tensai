import SwiftUI

/// A button style that displays a stroke around a content label.
struct OutlinedButtonStyle: ButtonStyle {
    
    /// The button color.
    private let color: Color
    
    /// Creates a button style with a stroke outline.
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
                .foregroundColor(color)
                .padding(.vertical, DrawingConstants.verticalPadding)
                .padding(.horizontal, DrawingConstants.horizontalPadding)
                .background(
                    ZStack {
                        Self.buttonShape.fill(backgroundColor)
                        Self.buttonShape
                            .stroke(
                                color,
                                lineWidth: DrawingConstants.borderWidth
                            )
                    }
                )
                .animation(.default, value: buttonIsEnabled)
        }
        
        /// The current background color of the button.
        private var backgroundColor: Color {
            if !buttonIsEnabled {
                return .clear
            }
            if configuration.isPressed {
                return color
                    .opacity(DrawingConstants.opacityWhenButtonIsPressed)
            }
            return .clear
        }
        
        /// The current button color.
        private var color: Color {
            if !buttonIsEnabled {
                return AppTheme.ColorPalette.disabled.contentColor
            }
            return defaultColor
        }
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The border width of the button.
        static let borderWidth: CGFloat = 4
        
        /// The corner radius of the button.
        static let cornerRadius: CGFloat = 16
        
        /// The horizontal padding in the button.
        static let horizontalPadding = verticalPadding * 2
        
        /// The opacity of the button when it is pressed.
        static let opacityWhenButtonIsPressed = 0.25
        
        /// The vertical padding in the button.
        static let verticalPadding: CGFloat = 16
    }
}

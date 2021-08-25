import SwiftUI

/// A simple button with a text label.
struct SanaButton: View {
    
    /// The title that is displayed on this button.
    private let title: String
    
    /// The type of this button.
    private let type: AppTheme.ButtonType
    
    /// The color mode that makes sense for this button’s context.
    private let colorMode: AppTheme.ColorMode
    
    /// The maximum width of this button.
    private let maxWidth: CGFloat?
    
    /// The action to perform when a user taps on this button.
    private let action: () -> Void
    
    /// The font size of the title.
    @ScaledMetric private var fontSize = DrawingConstants.defaultFontSize
    
    /// Creates a button with the specified title, type, color mode, and action.
    ///
    /// - Parameter title:     The title that is displayed on the button.
    /// - Parameter type:      The button type. The default is `.plain`.
    /// - Parameter colorMode: The color mode that makes sense for the button’s
    ///                        context. The default is `.primary`.
    /// - Parameter maxWidth:  The maximum width of the button.
    /// - Parameter action:    The action to perform when a user taps on the
    ///                        button.
    init(
        _ title: String,
        type: AppTheme.ButtonType = .plain,
        colorMode: AppTheme.ColorMode = .primary,
        maxWidth: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.type = type
        self.colorMode = colorMode
        self.maxWidth = maxWidth
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .fontWeight(.semibold)
                .frame(maxWidth: maxWidth)
        }
            .buttonStyle(Style(type: type, colorMode: colorMode))
    }
    
    /// A style that is applied to the button.
    private struct Style: ButtonStyle {
        
        /// The button type.
        private let type: AppTheme.ButtonType
        
        /// The color pair that is used on the button.
        private let colorPair: AppTheme.ColorPair
        
        /// Creates a style that is applied to the button.
        ///
        /// - Parameter type:      The button type.
        /// - Parameter colorMode: The color mode that makes sense for the
        ///                        button’s context.
        init(type: AppTheme.ButtonType, colorMode: AppTheme.ColorMode) {
            self.type = type
            self.colorPair = colorMode.colorPair
        }
        
        func makeBody(configuration: Configuration) -> some View {
            return ContainerView(
                type: type,
                defaultColorPair: colorPair,
                configuration: configuration
            )
        }
        
        /// A container view for the button style.
        private struct ContainerView: View {
            
            /// The button type.
            let type: AppTheme.ButtonType
            
            /// The default color pair when the button is idle.
            let defaultColorPair: AppTheme.ColorPair
            
            /// The properties of the button.
            let configuration: Configuration
            
            /// Indicates whether the button allows user interaction.
            @Environment(\.isEnabled) private var buttonIsEnabled
            
            var body: some View {
                configuration.label
                    .multilineTextAlignment(.center)
                    .foregroundColor(currentForegroundColor)
                    .padding(.vertical, DrawingConstants.verticalPadding)
                    .padding(.horizontal, horizontalPadding)
                    .background(background)
                    .animation(.default, value: buttonIsEnabled)
            }
            
            /// The background of the button.
            private var background: some View {
                ZStack {
                    DrawingConstants.buttonShape
                        .fill(currentBackgroundColor)
                        .shadow(radius: currentShadowRadius)
                    if configuration.isPressed {
                        DrawingConstants.buttonShape
                            .fill(currentHighlightColor)
                    }
                    if let borderColor = self.borderColor {
                        DrawingConstants.buttonShape
                            .stroke(
                                borderColor,
                                lineWidth: DrawingConstants
                                    .outlinedButtonBorderWidth
                            )
                    }
                }
            }
            
            /// The border color of the button.
            private var borderColor: Color? {
                if type != .outlined {
                    return nil
                }
                if !buttonIsEnabled {
                    return AppTheme.ColorPalette.disabled.contentColor
                }
                return defaultColorPair.mainColor
            }
            
            /// The current background color of the button.
            private var currentBackgroundColor: Color {
                if type != .filled {
                    return .clear
                }
                if !buttonIsEnabled {
                    return AppTheme.ColorPalette.disabled.mainColor
                }
                return defaultColorPair.mainColor
            }
            
            /// The current foreground color of the button.
            private var currentForegroundColor: Color {
                if !buttonIsEnabled {
                    return AppTheme.ColorPalette.disabled.contentColor
                }
                if type == .filled {
                    return defaultColorPair.contentColor
                }
                return defaultColorPair.mainColor
            }
            
            /// The current highlight color of the button when it is pressed.
            private var currentHighlightColor: Color {
                if !configuration.isPressed {
                    return .clear
                }
                let baseColor = (type == .filled)
                    ? Color.white
                    : defaultColorPair.mainColor
                return baseColor.opacity(DrawingConstants.highlightOpacity)
            }
            
            /// The current “radius” of the button’s shadow.
            private var currentShadowRadius: CGFloat {
                if type != .filled || !buttonIsEnabled {
                    return 0
                }
                if configuration.isPressed {
                    return DrawingConstants.defaultShadowRadius * 2
                }
                return DrawingConstants.defaultShadowRadius
            }
            
            /// The horizontal padding in the button.
            private var horizontalPadding: CGFloat {
                if type == .plain {
                    return DrawingConstants.verticalPadding
                }
                return DrawingConstants.verticalPadding * 2
            }
        }
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The button shape.
        static let buttonShape = RoundedRectangle(cornerRadius: cornerRadius)
        
        /// The default font size of the title.
        static let defaultFontSize: CGFloat = 16
        
        /// The default “radius” of the button’s shadow.
        static let defaultShadowRadius: CGFloat = 4
        
        /// The highlight opacity of the button when it is pressed.
        static let highlightOpacity: Double = 0.25
        
        /// The border width of an outlined button.
        static let outlinedButtonBorderWidth: CGFloat = 4
        
        /// The vertical padding in the button.
        static let verticalPadding: CGFloat = 16
        
        /// The corner radius of the button.
        private static let cornerRadius: CGFloat = 16
    }
}

#if DEBUG
struct SanaButton_Previews: PreviewProvider {
    static var previews: some View {
        let buttonTypes: [AppTheme.ButtonType] = [.filled, .outlined, .plain]
        let colorModes: [AppTheme.ColorMode] = [.primary, .secondary, .danger]
        return VStack(spacing: 16) {
            ForEach(buttonTypes, id: \.self) { type in
                ForEach(colorModes, id: \.self) { colorMode in
                    SanaButton("Press Me", type: type, colorMode: colorMode) {}
                }
                SanaButton("Press Me", type: type) {}
                    .disabled(true)
            }
        }
            .padding()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
#endif

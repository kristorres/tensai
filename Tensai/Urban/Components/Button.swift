import SwiftUI

/// A simple button with a text label.
struct UrbanButton: View {
    
    /// Creates a button with the given title.
    ///
    /// - Parameter title:    The title that is displayed on the button.
    /// - Parameter icon:     The ID of the SF Symbol that appears next to the
    ///                       title. The default is `nil`.
    /// - Parameter variant:  The button type. The default is `.plain`.
    /// - Parameter color:    The “color” that makes sense for the button’s
    ///                       context. The default is `.primary`.
    /// - Parameter maxWidth: The maximum width of the button. The default is
    ///                       `nil`.
    /// - Parameter action:   The action to perform when the user taps on the
    ///                       button.
    init(
        _ title: String,
        icon: String? = nil,
        variant: Variant = .plain,
        color: ColorStyle = .primary,
        maxWidth: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.icon = icon
        self.variant = variant
        self.color = color
        self.maxWidth = maxWidth
        self.action = action
    }
    
    /// The title that is displayed on the button.
    private let title: String
    
    /// The ID of the SF Symbol that appears next to the title.
    private let icon: String?
    
    /// The button type.
    private let variant: Variant
    
    /// The “color” that makes sense for the button’s context.
    private let color: ColorStyle
    
    /// The maximum width of the button.
    private let maxWidth: CGFloat?
    
    /// The action to perform when the user taps on the button.
    private let action: () -> Void
    
    /// The app theme.
    @Environment(\.theme) private var theme
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                if let icon = self.icon {
                    Image(systemName: icon)
                }
                Text(title).fontWeight(.semibold)
            }
                .font(contentFont)
                .frame(maxWidth: maxWidth)
        }
            .buttonStyle(Style(variant: variant, color: color))
    }
    
    /// The font of the button’s content.
    private var contentFont: Font {
        let fontSize = theme.typography.buttonFontSize
        
        if let buttonTypeface = theme.typography.buttonTypeface {
            return .custom(buttonTypeface, fixedSize: fontSize)
        }
        
        return .system(size: fontSize)
    }
    
    /// A color style that makes sense for the button’s context.
    enum ColorStyle {
        case primary
        case secondary
        case danger
    }
    
    /// A button type.
    enum Variant {
        
        /// A button type that displays a container with a solid color fill
        /// around a content label.
        case filled
        
        /// A button type that displays a stroke around a content label.
        case outlined
        
        /// A button type that does not decorate its content.
        case plain
    }
    
    /// A style that is applied to the button.
    private struct Style: ButtonStyle {
        
        /// The button type.
        let variant: Variant
        
        /// The “color” that makes sense for the button’s context.
        let color: ColorStyle
        
        func makeBody(configuration: Configuration) -> some View {
            return ContainerView(
                variant: variant,
                colorStyle: color,
                configuration: configuration
            )
        }
        
        /// A container view for the button style.
        private struct ContainerView: View {
            
            /// The button type.
            let variant: Variant
            
            /// The color style that makes sense for the button’s context.
            let colorStyle: ColorStyle
            
            /// The properties of the button.
            let configuration: Configuration
            
            /// The app theme.
            @Environment(\.theme) private var theme
            
            /// Indicates whether the button allows user interaction.
            @Environment(\.isEnabled) private var buttonIsEnabled
            
            var body: some View {
                configuration.label
                    .multilineTextAlignment(.center)
                    .foregroundColor(currentForegroundColor)
                    .padding(.vertical, Constants.verticalPadding)
                    .padding(.horizontal, horizontalPadding)
                    .background(background)
                    .animation(.default, value: buttonIsEnabled)
            }
            
            /// The background of the button.
            private var background: some View {
                let buttonShape = RoundedRectangle(
                    cornerRadius: theme.cornerRadius
                )
                
                return ZStack {
                    buttonShape.fill(currentBackgroundColor)
                    if configuration.isPressed {
                        buttonShape.fill(currentHighlightColor)
                    }
                    if let borderColor = self.borderColor {
                        buttonShape.stroke(
                            borderColor,
                            lineWidth: Constants.outlinedButtonBorderWidth
                        )
                    }
                }
            }
            
            /// The border color of the button.
            private var borderColor: Color? {
                if variant != .outlined {
                    return nil
                }
                if !buttonIsEnabled {
                    return theme.palette.disabled.content
                }
                
                return defaultColorPair.main
            }
            
            /// The current background color of the button.
            private var currentBackgroundColor: Color {
                if variant != .filled {
                    return .clear
                }
                if !buttonIsEnabled {
                    return theme.palette.disabled.main
                }
                
                return defaultColorPair.main
            }
            
            /// The current foreground color of the button.
            private var currentForegroundColor: Color {
                if !buttonIsEnabled {
                    return theme.palette.disabled.content
                }
                if variant == .filled {
                    return defaultColorPair.content
                }
                
                return defaultColorPair.main
            }
            
            /// The current highlight color of the button when it is pressed.
            private var currentHighlightColor: Color {
                if !configuration.isPressed {
                    return .clear
                }
                
                let baseColor = (variant == .filled)
                    ? Color.white
                    : defaultColorPair.main
                
                return baseColor.opacity(Constants.highlightOpacity)
            }
            
            /// The default main/content color pair when the button is idle.
            private var defaultColorPair: MCColorPair {
                switch colorStyle {
                case .primary: return theme.palette.primary
                case .secondary: return theme.palette.secondary
                case .danger: return theme.palette.danger
                }
            }
            
            /// The horizontal padding in the button.
            private var horizontalPadding: CGFloat {
                if variant == .plain {
                    return Constants.verticalPadding
                }
                
                return Constants.verticalPadding * 2
            }
        }
    }
    
    private struct Constants {
        static let highlightOpacity: Double = 0.25
        static let outlinedButtonBorderWidth: CGFloat = 2
        static let verticalPadding: CGFloat = 8
    }
}

#if DEBUG
struct UrbanButton_Previews: PreviewProvider {
    static var previews: some View {
        let variants: [UrbanButton.Variant] = [.filled, .outlined, .plain]
        let colors: [UrbanButton.ColorStyle] = [.primary, .secondary, .danger]
        
        return Group {
            VStack(spacing: 16) {
                ForEach(variants, id: \.self) { variant in
                    ForEach(colors, id: \.self) { color in
                        UrbanButton(
                            "Press Me",
                            variant: variant,
                            color: color
                        ) {}
                    }
                    UrbanButton("Press Me", icon: "plus", variant: variant) {}
                        .disabled(true)
                }
            }
                .padding()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("UrbanButton (Light Mode)")
            
            VStack(spacing: 16) {
                ForEach(variants, id: \.self) { variant in
                    ForEach(colors, id: \.self) { color in
                        UrbanButton(
                            "Press Me",
                            variant: variant,
                            color: color,
                            maxWidth: 100
                        ) {}
                    }
                    UrbanButton(
                        "Press Me",
                        icon: "plus",
                        variant: variant,
                        maxWidth: 100
                    ) {}
                        .disabled(true)
                }
            }
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("UrbanButton (Dark Mode)")
        }
    }
}
#endif

import SwiftUI

/// A button style that conforms to the current app theme.
///
/// You can also use `.urban` to construct this style.
struct UrbanButtonStyle: ButtonStyle {
    
    /// Creates a button style that conforms to the current app theme.
    ///
    /// - Parameter variant:  The button type. The default is `.plain`.
    /// - Parameter colorSet: The color set that makes sense for the button’s
    ///                       context. The default is `.primary`.
    init(variant: Variant = .plain, color colorSet: ColorSet = .primary) {
        self.variant = variant
        self.colorSet = colorSet
    }
    
    /// The button type.
    private let variant: Variant
    
    /// The color set that makes sense for the button’s context.
    private let colorSet: ColorSet
    
    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each `Button` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration: The properties of the button.
    ///
    /// - Returns: The button’s body.
    func makeBody(configuration: Configuration) -> some View {
        return ContainerView(
            variant: variant,
            colorSet: colorSet,
            configuration: configuration
        )
    }
    
    /// A color set that makes sense for the context of a button with the
    /// `UrbanButtonStyle`.
    enum ColorSet {
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
    
    /// A container view for the button style.
    private struct ContainerView: View {
        
        /// The button type.
        let variant: Variant
        
        /// The color set that makes sense for the button’s context.
        let colorSet: ColorSet
        
        /// The properties of the button.
        let configuration: Configuration
        
        /// The Urban theme.
        @Environment(\.urbanTheme) private var theme
        
        /// Indicates whether the button allows user interaction.
        @Environment(\.isEnabled) private var buttonIsEnabled
        
        var body: some View {
            configuration.label
                .font(theme.typography.button)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .foregroundColor(foregroundColor)
                .padding(.vertical, Constants.verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .background(background)
                .clipShape(shape)
                .overlay(borderLayer)
                .animation(.default, value: buttonIsEnabled)
        }
        
        /// The background of the button.
        private var background: some View {
            ZStack {
                baseBackgroundColor
                if configuration.isPressed {
                    highlightColor
                }
            }
        }
        
        /// The base background color of the button.
        private var baseBackgroundColor: Color {
            if variant != .filled {
                return .clear
            }
            if !buttonIsEnabled {
                return theme.palette.disabled.main
            }
            
            return enabledColorPair.main
        }
        
        /// The border “layer” of the button.
        private var borderLayer: some View {
            let borderColor = buttonIsEnabled
                ? enabledColorPair.main
                : theme.palette.disabled.content
            
            return Group {
                if variant == .outlined {
                    shape.stroke(
                        borderColor,
                        lineWidth: Constants.outlinedButtonBorderWidth
                    )
                }
            }
        }
        
        /// The main/content color pair when the button is enabled.
        private var enabledColorPair: MCColorPair {
            switch colorSet {
            case .primary: return theme.palette.primary
            case .secondary: return theme.palette.secondary
            case .danger: return theme.palette.danger
            }
        }
        
        /// The foreground color of the button.
        private var foregroundColor: Color {
            if !buttonIsEnabled {
                return theme.palette.disabled.content
            }
            if variant == .filled {
                return enabledColorPair.content
            }
            
            return enabledColorPair.main
        }
        
        /// The highlight color of the button when it is pressed.
        private var highlightColor: Color {
            let baseColor = (variant == .filled)
                ? Color.white
                : enabledColorPair.main
            
            return baseColor.opacity(Constants.highlightOpacity)
        }
        
        /// The horizontal padding in the button.
        private var horizontalPadding: CGFloat {
            if variant == .plain {
                return Constants.verticalPadding
            }
            
            return Constants.verticalPadding * 2
        }
        
        /// The button shape.
        private var shape: some Shape {
            RoundedRectangle(cornerRadius: theme.cornerRadius)
        }
    }
    
    /// An internal struct that contains drawing constants.
    private struct Constants {
        static let highlightOpacity: Double = 0.25
        static let outlinedButtonBorderWidth: CGFloat = 2
        static let verticalPadding: CGFloat = 8
    }
}

extension ButtonStyle where Self == UrbanButtonStyle {
    
    /// Returns a button style that conforms to the current app theme.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the `buttonStyle(_:)` modifier.
    ///
    /// - Parameter variant:  The button type. The default is `.plain`.
    /// - Parameter colorSet: The color set that makes sense for the button’s
    ///                       context. The default is `.primary`.
    ///
    /// - Returns: The button style.
    static func urban(
        variant: UrbanButtonStyle.Variant = .plain,
        color colorSet: UrbanButtonStyle.ColorSet = .primary
    ) -> Self {
        return .init(variant: variant, color: colorSet)
    }
}

#if DEBUG
struct UrbanButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        let variants: [UrbanButtonStyle.Variant] = [.filled, .outlined, .plain]
        let colors: [UrbanButtonStyle.ColorSet] = [
            .primary,
            .secondary,
            .danger
        ]
        
        return Group {
            VStack(spacing: 16) {
                ForEach(variants, id: \.self) { variant in
                    ForEach(colors, id: \.self) { color in
                        Button("Press Me") {}
                            .buttonStyle(.urban(variant: variant, color: color))
                    }
                    Button("Press Me") {}
                        .buttonStyle(.urban(variant: variant))
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
                        Button(action: {}) {
                            Text("Press Me").frame(maxWidth: 100)
                        }
                            .buttonStyle(.urban(variant: variant, color: color))
                    }
                    Button(action: {}) {
                        Text("Press Me").frame(maxWidth: 100)
                    }
                        .buttonStyle(.urban(variant: variant))
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

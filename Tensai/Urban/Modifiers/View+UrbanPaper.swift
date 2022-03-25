import SwiftUI

extension View {
    
    /// Displays the view on a paperlike surface.
    ///
    /// - Parameter hasBorder: Indicates whether the paper element has a border.
    ///                        The default is `false`.
    /// - Parameter hasShadow: Indicates whether the paper element has a shadow.
    ///                        The default is `true`.
    ///
    /// - Returns: The modified view.
    func urbanPaper(
        border hasBorder: Bool = false,
        shadow hasShadow: Bool = true
    ) -> some View {
        return modifier(UrbanPaper(hasBorder: hasBorder, hasShadow: hasShadow))
    }
}

/// A simple view modifier that displays content on a paperlike surface.
fileprivate struct UrbanPaper: ViewModifier {
    
    /// Indicates whether the paper element has a border.
    let hasBorder: Bool
    
    /// Indicates whether the paper element has a shadow.
    let hasShadow: Bool
    
    /// The app theme.
    @Environment(\.theme) private var theme
    
    /// Returns the current body of the caller.
    ///
    /// - Parameter content: The content view.
    ///
    /// - Returns: The caller’s body.
    func body(content: Content) -> some View {
        return content
            .foregroundColor(theme.palette.surface.content)
            .background(theme.palette.surface.main)
            .clipShape(shape)
            .overlay(borderLayer)
            .shadow(radius: hasShadow ? 4 : 0)
    }
    
    /// The border “layer” of the paper element.
    private var borderLayer: some View {
        Group {
            if hasBorder {
                shape.stroke(theme.palette.surface.content, lineWidth: 2)
            }
        }
    }
    
    /// The shape of the paper element.
    private var shape: some Shape {
        RoundedRectangle(cornerRadius: theme.cornerRadius)
    }
}

#if DEBUG
struct UrbanPaper_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            cardExample(border: false)
                .padding()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("UrbanPaper (Light Mode)")
            
            cardExample(border: true)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("UrbanPaper (Dark Mode)")
        }
    }
    
    static func cardExample(border hasBorder: Bool) -> some View {
        return VStack(spacing: 0) {
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Tokyo")
                        .font(.title)
                    Text("Mon, 12:30 PM, Sunny")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .center) {
                    Text("23ºC")
                    Spacer()
                    Image(systemName: "sun.max.fill").renderingMode(.original)
                }
                    .font(.system(size: 72))
            }
                .padding()
            Divider()
            Button(action: {}) {
                Text("Expand").fontWeight(.semibold)
            }
                .buttonStyle(.urban())
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
            .urbanPaper(border: hasBorder)
            .frame(width: 320)
    }
}
#endif

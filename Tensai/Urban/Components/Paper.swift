import SwiftUI

/// A simple paper element that displays content.
struct UrbanPaper<Content>: View where Content: View {
    
    /// Creates a paper element with the given content.
    ///
    /// - Parameter hasBorder: Indicates whether the paper element has a border.
    ///                        The default is `false`.
    /// - Parameter hasShadow: Indicates whether the paper element has a shadow.
    ///                        The default is `true`.
    /// - Parameter content:   The closure to render the content of the paper
    ///                        element.
    init(
        border hasBorder: Bool = false,
        shadow hasShadow: Bool = true,
        content: @escaping () -> Content
    ) {
        self.hasBorder = hasBorder
        self.hasShadow = hasShadow
        self.content = content
    }
    
    /// Indicates whether the paper element has a border.
    private let hasBorder: Bool
    
    /// Indicates whether the paper element has a shadow.
    private let hasShadow: Bool
    
    /// The closure to render the content of the paper element.
    private let content: () -> Content
    
    /// The app theme.
    @Environment(\.theme) private var theme
    
    var body: some View {
        content()
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
        return UrbanPaper(border: hasBorder) {
            VStack(spacing: 0) {
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
                        Image(systemName: "sun.max.fill")
                            .renderingMode(.original)
                    }
                    .font(.system(size: 72))
                }
                    .padding()
                Divider()
                UrbanButton("Expand") {}
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
            .frame(width: 320)
    }
}
#endif

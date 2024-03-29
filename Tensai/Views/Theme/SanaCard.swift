import SwiftUI

/// A simple card that displays content.
struct SanaCard<Content>: View where Content: View {
    
    /// The closure to render the content of this card.
    let content: () -> Content
    
    /// The app theme.
    @Environment(\.theme) private var theme
    
    var body: some View {
        content()
            .background(
                Rectangle()
                    .fill(theme.colorPalette.surface.mainColor)
                    .shadow(radius: theme.shadowRadius)
            )
    }
}

#if DEBUG
struct SanaCard_Previews: PreviewProvider {
    static var previews: some View {
        SanaCard {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Word of the Day")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    VStack(alignment: .leading) {
                        Text("be•nev•o•lent")
                            .font(.title)
                        Text("adjective")
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading) {
                        Text("Well meaning and kindly.")
                        Text("“A benevolent smile.”")
                    }
                }
                    .padding()
                Divider()
                SanaButton("Learn More") {}
                    .padding(4)
            }
        }
            .frame(width: 320)
            .padding()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
#endif

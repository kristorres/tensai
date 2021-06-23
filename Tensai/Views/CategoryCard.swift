import SwiftUI

/// A category card.
struct CategoryCard: View {
    
    /// The category item.
    let categoryItem: CategoryItem
    
    /// The shape of a category card.
    private static let cardShape = RoundedRectangle(
        cornerRadius: DrawingConstants.cornerRadius
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Card Background")
                VStack(spacing: 0) {
                    Image(categoryItem.icon)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Category Icon Background"))
                    Divider()
                    Spacer(minLength: 0)
                    Text(categoryItem.name)
                        .font(font(in: geometry.size))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer(minLength: 0)
                }
            }
                .clipShape(Self.cardShape)
                .shadow(radius: DrawingConstants.shadowRadius)
        }
    }
    
    /// Returns the optimized font of the category name in the specified size.
    ///
    /// - Parameter size: The size.
    ///
    /// - Returns: The font.
    private func font(in size: CGSize) -> Font {
        return .system(
            size: min(size.width, size.height) * DrawingConstants.fontScale
        )
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The corner radius of a category card.
        static let cornerRadius: CGFloat = 16
        
        /// The font scale for the category name.
        static let fontScale: CGFloat = 0.1
        
        /// The “radius” of a category card’s shadow.
        static let shadowRadius: CGFloat = 4
    }
}

#if DEBUG
struct CategoryCard_Previews: PreviewProvider {
    
    static var exampleCategoryCard: some View {
        CategoryCard(categoryItem: CategoryItem.allCategoryItems[1])
            .aspectRatio(5 / 7, contentMode: .fit)
            .frame(width: 200)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
    static var previews: some View {
        Group {
            exampleCategoryCard
                .preferredColorScheme(.light)
                .previewDisplayName("Preview (Light Mode)")
            exampleCategoryCard
                .preferredColorScheme(.dark)
                .previewDisplayName("Preview (Dark Mode)")
        }
    }
}
#endif

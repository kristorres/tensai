import SwiftUI

/// A view where the player can select the category of the questions in the
/// trivia quiz.
struct CategoryMenuView: View {
    
    /// The environment color scheme.
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: DrawingConstants.scrollViewStackSpacing) {
                    Text("Start a New Quiz")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    Text("Please select a category.")
                        .font(.title2)
                        .fontWeight(.semibold)
                    categoryGrid(in: geometry.size)
                        .padding()
                }
            }
        }
            .background(backgroundColor.ignoresSafeArea())
    }
    
    /// The background color of this view.
    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(red: 0, green: 0.1059, blue: 0.2157)
        }
        return Color(red: 0.6235, green: 0.8471, blue: 1)
    }
    
    /// Returns the grid of categories that the player can select in the
    /// specified size.
    ///
    /// - Parameter size: The size.
    ///
    /// - Returns: The category grid.
    private func categoryGrid(in size: CGSize) -> some View {
        return LazyVGrid(
            columns: [gridItem(in: size)],
            spacing: 0,
            content: {
                ForEach(CategoryItem.allCategoryItems) {
                    CategoryCard(categoryItem: $0)
                        .aspectRatio(
                            DrawingConstants.cardAspectRatio,
                            contentMode: .fit
                        )
                        .padding(DrawingConstants.cardMargin)
                }
            }
        )
    }
    
    /// Returns a grid item in the specified size.
    ///
    /// - Parameter size: The size.
    ///
    /// - Returns: The grid item.
    private func gridItem(in size: CGSize) -> GridItem {
        let columnWidth = (size.width < DrawingConstants.minimumViewWidthForRegularColumnWidth)
            ? DrawingConstants.compactColumnWidth
            : DrawingConstants.regularColumnWidth
        return GridItem(.adaptive(minimum: columnWidth), spacing: 0)
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The aspect ratio of a category card.
        static let cardAspectRatio: CGFloat = 2 / 3
        
        /// The margin along all edges of a category card.
        static let cardMargin: CGFloat = 8
        
        /// The width of a “compact” column in the category grid.
        static let compactColumnWidth: CGFloat = 120
        
        /// The minimum width of this view required for the category grid to
        /// have “regular” column widths.
        static let minimumViewWidthForRegularColumnWidth: CGFloat = 360
        
        /// The width of a “regular” column in the category grid.
        static let regularColumnWidth: CGFloat = 160
        
        /// The spacing between subviews in the scroll view’s stack.
        static let scrollViewStackSpacing: CGFloat = 8
    }
}

#if DEBUG
struct CategoryMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let view = CategoryMenuView()
        return DevicePreviewGroup(name: "Category Menu View", view: view)
    }
}
#endif

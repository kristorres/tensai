import SwiftUI

/// A picker for selecting from a set of possible options.
struct SanaPicker<SelectionValue>: View where SelectionValue: Hashable {
    
    /// The possible options.
    private let options: [SelectionValue]
    
    /// The closure to map an option to its corresponding string label.
    private let optionLabel: (SelectionValue) -> String
    
    /// A binding to the currently selected option.
    @Binding private var selection: SelectionValue
    
    /// The index of the currently selected option.
    @State private var selectionIndex = 0
    
    /// The font size of the currently selected option.
    @ScaledMetric private var fontSize = DrawingConstants.defaultFontSize
    
    /// The environment color scheme.
    @Environment(\.colorScheme) private var colorScheme
    
    /// Creates a picker with a set of possible options.
    ///
    /// - Parameter options:     The possible options.
    /// - Parameter selection:   A binding to the currently selected option.
    /// - Parameter optionLabel: The closure to map an option to its
    ///                          corresponding string label.
    init(
        options: [SelectionValue],
        selection: Binding<SelectionValue>,
        optionLabel: @escaping (SelectionValue) -> String = { "\($0)" }
    ) {
        self.options = options
        self.optionLabel = optionLabel
        self._selection = selection
    }
    
    var body: some View {
        HStack {
            Text(optionLabel(selection))
                .font(.system(size: fontSize))
                .fontWeight(.semibold)
            Spacer()
            VStack {
                upArrowButton
                downArrowButton
            }
                .foregroundColor(AppTheme.ColorPalette.primary.mainColor)
        }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Rectangle().fill(DrawingConstants.backgroundColor))
            .onAppear {
                selectionIndex = options.firstIndex(of: selection) ?? 0
                selection = options[selectionIndex]
            }
    }
    
    /// The button that selects the next possible option.
    private var downArrowButton: some View {
        Button {
            selectionIndex = (selectionIndex == options.count - 1)
                ? 0
                : selectionIndex + 1
            updateSelection()
        } label: {
            arrowButtonImage(for: .down)
        }
    }
    
    /// The button that selects the previous possible option.
    private var upArrowButton: some View {
        Button {
            selectionIndex = (selectionIndex == 0)
                ? options.count - 1
                : selectionIndex - 1
            updateSelection()
        } label: {
            arrowButtonImage(for: .up)
        }
    }
    
    /// Returns the arrow button image in the specified direction.
    ///
    /// - Parameter direction: The arrow direction.
    ///
    /// - Returns: A view with the arrow button image.
    private func arrowButtonImage(for direction: ArrowDirection) -> some View {
        let symbolName = "arrowtriangle.\(direction.rawValue).square.fill"
        return Image(systemName: symbolName)
            .resizable()
            .scaledToFit()
            .frame(width: DrawingConstants.arrowButtonWidth)
    }
    
    /// Updates the currently selected option.
    private func updateSelection() {
        selection = options[selectionIndex]
        EffectsManager.shared.playSound("select")
    }
    
    /// An internal type that represents a direction for an arrow.
    private enum ArrowDirection: String {
        case up
        case down
    }
}

/// A struct that contains drawing constants.
fileprivate struct DrawingConstants {
    
    /// The width of the arrow buttons.
    static let arrowButtonWidth: CGFloat = 24
    
    /// The background color of a picker.
    static let backgroundColor: Color = Color.primary.opacity(backgroundOpacity)
    
    /// The default font size of the currently selected option.
    static let defaultFontSize: CGFloat = 16
    
    /// The opacity of a picker’s background.
    private static let backgroundOpacity = 0.125
}

#if DEBUG
struct SanaPicker_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    private struct Preview: View {
        @State private var selectedCategory = "?????"
        var body: some View {
            VStack {
                Text("Category: \(selectedCategory)")
                SanaPicker<String>(
                    options: TriviaQuizConfig.allCategories,
                    selection: $selectedCategory
                )
            }
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif

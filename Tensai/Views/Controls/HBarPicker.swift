import SwiftUI

/// A horizontal bar control for selecting from a list of possible options.
struct HBarPicker: View {
    
    // -------------------------------------------------------------------------
    // MARK:- Properties
    // -------------------------------------------------------------------------
    
    /// The list of possible options.
    let options: [String]
    
    /// A binding to a property that determines the index of the currently
    /// selected option.
    @Binding var selectionIndex: Int {
        didSet {
            EffectsManager.shared.playSound("select")
        }
    }
    
    var body: some View {
        HStack(spacing: DrawingConstants.spacing) {
            Button(action: selectPreviousOption) {
                arrowButtonImage(for: .left)
            }
                .disabled(selectionIndex == 0)
            Text(options[selectionIndex])
                .font(.headline)
                .frame(maxWidth: DrawingConstants.maximumOptionTextFieldWidth)
                .cardify(backgroundColor: Color("Option Background"))
            Button(action: selectNextOption) {
                arrowButtonImage(for: .right)
            }
                .disabled(selectionIndex == options.count - 1)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private methods
    // -------------------------------------------------------------------------
    
    /// Returns the arrow button image in the specified direction.
    ///
    /// - Parameter direction: The arrow direction.
    ///
    /// - Returns: A view with the arrow button image.
    private func arrowButtonImage(for direction: ArrowDirection) -> some View {
        return Image(systemName: "arrowtriangle.\(direction.rawValue).fill")
            .font(.system(size: DrawingConstants.arrowFontSize))
    }
    
    /// Selects the next possible option.
    private func selectNextOption() {
        selectionIndex += 1
    }
    
    /// Selects the previous possible option.
    private func selectPreviousOption() {
        selectionIndex -= 1
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Nested struct
    // -------------------------------------------------------------------------
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The font size for the arrows.
        static let arrowFontSize = CGFloat(40)
        
        /// The maximum width of the text field that contains the currently
        /// selected option.
        static let maximumOptionTextFieldWidth = CGFloat(400)
        
        /// The spacing between the text field that contains the currently
        /// selected option, and two arrow buttons.
        static let spacing = CGFloat(16)
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Nested enum
    // -------------------------------------------------------------------------
    
    /// An internal type that represents a direction for an arrow.
    private enum ArrowDirection: String {
        case left
        case right
    }
}

#if DEBUG
struct HBarPicker_Previews: PreviewProvider {
    static var previews: some View {
        let greetings = ["Hello, world! 🇺🇸", "おはよう、世界！ 🇯🇵", "안녕, 세계! 🇰🇷"]
        return Group {
            ForEach(greetings.indices) { index in
                HBarPicker(options: greetings, selectionIndex: .constant(index))
                    .preview()
                    .previewDisplayName("Preview \(index + 1)")
            }
            HBarPicker(options: greetings, selectionIndex: .constant(0))
                .preview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Preview 4")
        }
    }
}

fileprivate extension HBarPicker {
    func preview() -> some View {
        return self
            .frame(maxWidth: .infinity)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif

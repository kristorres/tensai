import SwiftUI

/// A modifier that embeds a view in a card.
fileprivate struct Cardify: ViewModifier {
    
    /// The background color of the card.
    let backgroundColor: Color
    
    /// The border color of the card.
    let borderColor: Color
    
    func body(content: Content) -> some View {
        let cardRectangle = RoundedRectangle(
            cornerRadius: DrawingConstants.cornerRadius
        )
        
        return content
            .padding()
            .background(
                ZStack {
                    cardRectangle.fill(backgroundColor)
                    cardRectangle.strokeBorder(
                        borderColor,
                        lineWidth: DrawingConstants.borderWidth
                    )
                }
            )
            
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The border width for the card.
        static let borderWidth = CGFloat(4)
        
        /// The corner radius for the card.
        static let cornerRadius = CGFloat(16)
    }
}

extension View {
    
    /// Embeds a view in a card.
    ///
    /// - Parameter backgroundColor:     The background color of the card.
    ///                                  The default is `.clear`.
    /// - Parameter borderColor:         The border color of the card.
    ///                                  The default is `.primary`.
    ///
    /// - Returns: The card view.
    func cardify(
        backgroundColor: Color = .clear,
        borderColor: Color = .primary
    ) -> some View {
        return self.modifier(
            Cardify(
                backgroundColor: backgroundColor,
                borderColor: borderColor
            )
        )
    }
}

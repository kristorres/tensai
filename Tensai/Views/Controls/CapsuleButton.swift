import SwiftUI

/// A capsule-shaped button that performs an action when tapped on.
struct CapsuleButton: View {
    
    /// The title that is displayed on this button.
    let title: String
    
    /// The action to perform when a user taps on this button.
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.title)
                .fontWeight(.heavy)
                .padding(.all, 8)
                .frame(maxWidth: DrawingConstants.maximumButtonWidth)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
        }
    }
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The maximum width of a button.
        static let maximumButtonWidth = CGFloat(400)
    }
}

#if DEBUG
struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(title: "Play", action: {})
            .frame(maxWidth: .infinity)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif

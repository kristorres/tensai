import SwiftUI

extension Color {
    
    /// Creates a dynamic color with light and dark variants.
    ///
    /// - Parameter lightVariant: The light variant.
    /// - Parameter darkVariant:  The dark variant.
    ///
    /// - Returns: The dynamic color.
    static func dynamic(
        light lightVariant: Color,
        dark darkVariant: Color
    ) -> Color {
        return Color(
            uiColor: UIColor { traitCollection in
                let darkModeIsOn = (traitCollection.userInterfaceStyle == .dark)
                return UIColor(darkModeIsOn ? darkVariant : lightVariant)
            }
        )
    }
}

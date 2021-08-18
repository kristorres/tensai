import SwiftUI

/// The global app theme.
///
/// The purpose of the theme is to apply a consistent tone to the app. You can
/// customize design aspects such as the colors, typography, and more.
struct AppTheme {
    
    /// The color palette.
    struct ColorPalette {
        
        /// The color displayed most frequently across the app’s screens and
        /// components.
        static let primary = Color("Primary")
        
        /// The shade of the `primary` color used when a control is pressed.
        static let primaryWhenPressed = Color("Primary (Pressed)")
        
        /// The color used to accent and distinguish the app.
        static let secondary = Color("Secondary")
        
        /// The shade of the `secondary` color used when a control is pressed.
        static let secondaryWhenPressed = Color("Secondary (Pressed)")
        
        /// The color used to represent warnings, errors, and other destructive
        /// actions.
        static let danger = Color("Danger")
        
        /// The shade of the `danger` color used when a control is pressed.
        static let dangerWhenPressed = Color("Danger (Pressed)")
        
        /// The color displayed across distinguishable surfaces.
        static let surface = Color("Surface")
        
        /// The baseline background color.
        static let background = Color("Background")
        
        /// The color of elements that appear “on” top of views with a `primary`
        /// color fill.
        static let onPrimary = Color("On Primary")
        
        /// The color of elements that appear “on” top of views with a
        /// `secondary` color fill.
        static let onSecondary = Color("On Secondary")
        
        /// The color of elements that appear “on” top of views with a `danger`
        /// color fill.
        static let onDanger = Color("On Danger")
        
        /// The color of elements that appear “on” top of views with a `surface`
        /// color fill.
        static let onSurface = Color("On Surface")
        
        /// The color of elements that appear “on” top of views with a
        /// `background` color fill.
        static let onBackground = Color("On Background")
    }
}

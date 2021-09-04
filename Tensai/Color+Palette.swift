import SwiftUI

extension Color {
    
    /// A main/content color pair.
    typealias Pair = (mainColor: Color, contentColor: Color)
    
    /// A color palette.
    struct Palette {
        
        /// The name of this color palette.
        let name: String
        
        /// The main/content color pair used most frequently across the app.
        var primary: Color.Pair {
            colorPair(name: "Primary")
        }
        
        /// The main/content color pair used to accent and distinguish the app.
        var secondary: Color.Pair {
            colorPair(name: "Secondary")
        }
        
        /// The main/content color pair used to indicate warnings, errors, or
        /// other destructive actions.
        var danger: Color.Pair {
            colorPair(name: "Danger")
        }
        
        /// The main/content color pair used on surfaces of components, such as
        /// cards, sheets, and menus.
        var surface: Color.Pair {
            colorPair(name: "Surface")
        }
        
        /// The main/content color pair used on screen backgrounds.
        var background: Color.Pair {
            colorPair(name: "Background")
        }
        
        /// The main/content color pair used on disabled controls.
        var disabled: Color.Pair {
            colorPair(name: "Disabled")
        }
        
        /// Returns a color with the specified color resource.
        ///
        /// - Parameter name: The name of the color resource.
        ///
        /// - Returns: The color.
        private func color(name: String) -> Color {
            let paletteName = self.name
            let colorName = name
            return Color("\(paletteName)/\(colorName)")
        }
        
        /// Returns a main/content color pair with the specified name.
        ///
        /// - Parameter name: The name of the color pair.
        ///
        /// - Returns:
        ///   - mainColor:    The main color.
        ///   - contentColor: The color of elements that appear “on” top of
        ///                   components with a `mainColor` fill.
        private func colorPair(name: String) -> Color.Pair {
            let mainColor = color(name: name)
            let contentColor = color(name: "On \(name)")
            return (mainColor, contentColor)
        }
    }
}

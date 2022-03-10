import SwiftUI

/// A main/content color pair.
typealias MCColorPair = (main: Color, content: Color)

/// A color palette.
///
/// In order for the palette to work, there must be a folder in an Asset Catalog
/// with the palette `name`, and the folder must contain the following color
/// sets organized like so:
///
/// ```
/// main
/// ├── primary.colorset
/// ├── secondary.colorset
/// ├── danger.colorset
/// ├── surface.colorset
/// ├── background.colorset
/// └── disabled.colorset
/// content
/// ├── primary.colorset
/// ├── secondary.colorset
/// ├── danger.colorset
/// ├── surface.colorset
/// ├── background.colorset
/// └── disabled.colorset
/// ```
///
/// Using a color from the palette in a SwiftUI view is very straightforward.
///
/// ```
/// palette.primary.main
/// ```
struct UrbanPalette {
    
    /// The name of the color palette.
    let name: String
    
    /// The main/content color pair used most frequently across the app.
    var primary: MCColorPair {
        colorPair(name: "primary")
    }
    
    /// The main/content color pair used to accent and distinguish the app.
    var secondary: MCColorPair {
        colorPair(name: "secondary")
    }
    
    /// The main/content color pair used to indicate warnings, errors, or other
    /// destructive actions.
    var danger: MCColorPair {
        colorPair(name: "danger")
    }
    
    /// The main/content color pair used on surface components, such as cards,
    /// sheets, and menus.
    var surface: MCColorPair {
        colorPair(name: "surface")
    }
    
    /// The main/content color pair used on screen backgrounds.
    var background: MCColorPair {
        colorPair(name: "background")
    }
    
    /// The main/content color pair used on disabled controls.
    var disabled: MCColorPair {
        colorPair(name: "disabled")
    }
    
    /// Returns a color from the palette folder in an Asset Catalog.
    ///
    /// The palette folder and subfolder provide the namespace of the color set,
    /// in that order.
    ///
    /// - Parameter name:      The name of the color set to load.
    /// - Parameter subfolder: The name of the subfolder that contains the color
    ///                        set.
    ///
    /// - Returns: The color.
    private func color(name: String, subfolder: String) -> Color {
        let paletteName = self.name
        let colorName = name
        
        return Color("\(paletteName)/\(subfolder)/\(colorName)")
    }
    
    /// Returns the main and content colors with the given name as a pair.
    ///
    /// The main and content colors are in the *main* and *content* subfolders,
    /// respectively.
    ///
    /// - Parameter name: The name of the main and content colors.
    ///
    /// - Returns:
    ///   - main:    The main color.
    ///   - content: The color of elements that appear “on” top of components
    ///              with a `main` color fill.
    private func colorPair(name: String) -> MCColorPair {
        let mainColor = color(name: name, subfolder: "main")
        let contentColor = color(name: name, subfolder: "content")
        
        return (mainColor, contentColor)
    }
}

extension Color {
    
    static let torresBlue = Color.dynamic(
        light: Color(red: 0.102, green: 0.3922, blue: 0.8431),
        dark: Color(red: 0.5529, green: 0.7961, blue: 1)
    )
    
    static let torresGold = Color.dynamic(
        light: Color(red: 1, green: 0.7098, blue: 0),
        dark: Color(red: 0.9961, green: 0.8863, blue: 0.5137)
    )
    
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

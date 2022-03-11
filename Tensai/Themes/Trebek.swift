import SwiftUI

extension UrbanTheme {
    
    /// The Trebek theme.
    static let trebek: UrbanTheme = {
        var theme = UrbanTheme()
        theme.palette.primary.main = .dynamic(
            light: Color(red: 0.0902, green: 0.3922, blue: 0.8549),
            dark: Color(red: 0.6431, green: 0.7647, blue: 0.9569)
        )
        theme.palette.secondary.main = .dynamic(
            light: Color(red: 1, green: 0.6784, blue: 0),
            dark: Color(red: 1, green: 0.8667, blue: 0.5059)
        )
        theme.palette.surface.main = .dynamic(
            light: .white,
            dark: Color(red: 0.1686, green: 0.1804, blue: 0.2471)
        )
        theme.palette.background.main = .dynamic(
            light: Color(red: 0.6235, green: 0.8471, blue: 1),
            dark: Color(red: 0.0431, green: 0.1176, blue: 0.2353)
        )
        
        return theme
    }()
}

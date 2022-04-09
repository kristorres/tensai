import SwiftUI
import Urban

extension UrbanTheme {
    
    /// The Trebek theme.
    static let trebek: UrbanTheme = {
        var theme = UrbanTheme()
        
        theme.palette.primary.main = Color("trebek-primary-main")
        theme.palette.secondary.main = Color("trebek-secondary-main")
        theme.palette.surface.main = Color("trebek-surface-main")
        theme.palette.background.main = Color("trebek-background-main")
        
        theme.typography.button = .custom("Barlow Condensed Medium", size: 28)
        
        return theme
    }()
}

import Foundation

/// A category item with a name and icon.
struct CategoryItem: Identifiable {
    
    /// The name of the category.
    let name: String
    
    /// The icon for the category item.
    let icon: String
    
    var id: String {
        icon
    }
    
    /// An array of all possible category items that the player can select.
    static let allCategoryItems = [
        CategoryItem(name: "Any Category", icon: "mystery-box"),
        CategoryItem(name: "General Knowledge", icon: "lightbulb"),
        CategoryItem(name: "Books", icon: "books"),
        CategoryItem(name: "Film", icon: "clapperboard"),
        CategoryItem(name: "Music", icon: "music"),
        CategoryItem(name: "Musicals & Theater", icon: "theater"),
        CategoryItem(name: "Television", icon: "television"),
        CategoryItem(name: "Video Games", icon: "gamepad"),
        CategoryItem(name: "Board Games", icon: "board-game"),
        CategoryItem(name: "Science & Nature", icon: "flask-plant"),
        CategoryItem(name: "Computers", icon: "computer"),
        CategoryItem(name: "Mathematics", icon: "math"),
        CategoryItem(name: "Mythology", icon: "zeus"),
        CategoryItem(name: "Sports", icon: "volleyball"),
        CategoryItem(name: "Geography", icon: "world-map"),
        CategoryItem(name: "History", icon: "george-washington"),
        CategoryItem(name: "Politics", icon: "politics"),
        CategoryItem(name: "Art", icon: "palette"),
        CategoryItem(name: "Celebrities", icon: "celebrity"),
        CategoryItem(name: "Animals", icon: "koala"),
        CategoryItem(name: "Vehicles", icon: "car"),
        CategoryItem(name: "Comics", icon: "comics"),
        CategoryItem(name: "Gadgets", icon: "gadgets"),
        CategoryItem(name: "Anime & Manga", icon: "anime-eye"),
        CategoryItem(name: "Cartoons", icon: "leonardo")
    ]
}

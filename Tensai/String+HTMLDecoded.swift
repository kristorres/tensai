import Foundation

extension String {
    
    /// The HTML-decoded version of the string.
    ///
    /// ```
    /// let htmlSong = "Twice — <b>&quot;I Can&#8217;t Stop Me&quot;</b>"
    ///
    /// if let song = htmlSong.htmlDecoded {
    ///     print(song)  // Twice — "I Can’t Stop Me"
    /// }
    /// ```
    var htmlDecoded: String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return nil
        }
        
        return String(attributedString.string)
    }
}

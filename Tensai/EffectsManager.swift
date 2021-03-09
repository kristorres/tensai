import AVFoundation

/// An object that manages sound effects.
final class EffectsManager {
    
    /// The shared singleton effects manager object.
    static let shared = EffectsManager()
    
    /// The media player.
    private var mediaPlayer: AVPlayer!
    
    /// Plays the sound identified by the specified name.
    ///
    /// - Parameter name: The name of the audio file.
    func playSound(_ name: String) {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "mp3"
        ) else {
            fatalError("Failed to find audio file \(name).mp3.")
        }
        mediaPlayer = AVPlayer(url: url)
        mediaPlayer.seek(to: .zero)
        mediaPlayer.play()
    }
}

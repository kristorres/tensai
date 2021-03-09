import AVFoundation

/// The media player.
fileprivate var mediaPlayer: AVPlayer?

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
    mediaPlayer?.seek(to: .zero)
    mediaPlayer?.play()
}

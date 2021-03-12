import AVFoundation
import CoreHaptics

/// An object that manages sound effects.
final class EffectsManager {
    
    /// The shared singleton effects manager object.
    static let shared = EffectsManager()
    
    /// The media player.
    private var mediaPlayer: AVPlayer!
    
    /// The haptic engine.
    private var hapticEngine: CHHapticEngine!
    
    /// Indicates whether the haptic engine needs to be restarted.
    private var hapticEngineNeedsRestart = false
    
    /// Indicates whether the device supports haptic event playback.
    private var deviceSupportsHaptics: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    /// Creates an effects manager.
    init() {
        prepareHaptics()
    }
    
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
    
    /// “Shocks” the player for a specified number of seconds.
    ///
    /// If the device does not support haptic event playback, then this method
    /// will do nothing.
    ///
    /// - Parameter duration: The duration of the shock (in seconds).
    func shock(duration: Double) {
        if !deviceSupportsHaptics {
            return
        }
        do {
            if hapticEngineNeedsRestart {
                try hapticEngine.start()
                hapticEngineNeedsRestart = false
            }
            let hapticPattern = try CHHapticPattern(
                events: [shockEvent(duration: duration)],
                parameters: []
            )
            let hapticPlayer = try hapticEngine.makePlayer(with: hapticPattern)
            try hapticPlayer.start(atTime: 0)
        }
        catch {
            fatalError("Failed to shock the player.")
        }
    }
    
    /// Creates and starts the haptic engine.
    ///
    /// If the device does not support haptic event playback, then this method
    /// will do nothing.
    private func prepareHaptics() {
        if !deviceSupportsHaptics {
            return
        }
        do {
            hapticEngine = try CHHapticEngine()
            hapticEngine.stoppedHandler = { _ in
                self.hapticEngineNeedsRestart = true
            }
            try hapticEngine.start()
        }
        catch {
            fatalError("Failed to prepare haptics.")
        }
    }
    
    /// Returns a haptic event that “shocks” the player for a specified number
    /// of seconds.
    ///
    /// - Parameter duration: The duration of the shock (in seconds).
    private func shockEvent(duration: Double) -> CHHapticEvent {
        return CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            ],
            relativeTime: 0,
            duration: duration
        )
    }
}

import AVFoundation
import UIKit

@Observable
class SoundManager {
    var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: "soundEffectsEnabled") }
    }

    init() {
        self.soundEnabled = UserDefaults.standard.object(forKey: "soundEffectsEnabled") as? Bool ?? true
    }

    enum SoundEffect {
        case correctAnswer
        case wrongAnswer
        case quizComplete
        case achievement
    }

    func play(_ effect: SoundEffect) {
        guard soundEnabled else { return }
        switch effect {
        case .correctAnswer:
            AudioServicesPlaySystemSound(1057)
        case .wrongAnswer:
            AudioServicesPlaySystemSound(1053)
        case .quizComplete:
            AudioServicesPlaySystemSound(1025)
        case .achievement:
            AudioServicesPlaySystemSound(1026)
        }
    }
}

import UIKit
import AVFAudio

// 要リファクタ
final class DrumRollPlayer: @unchecked Sendable {
    private let audioPlayer: (drumRoll: AVAudioPlayer, drumRollFinish: AVAudioPlayer)? = {
        guard let drumRollSound = NSDataAsset(name: "Drum Roll"),
              let drumRollPlayer = try? AVAudioPlayer(data: drumRollSound.data),
              let drumRollFinishSound = NSDataAsset(name: "Drum Roll Finish"),
              let drumRollFinishSoundPlayer = try? AVAudioPlayer(data: drumRollFinishSound.data)
        else { return nil }

        return (drumRollPlayer, drumRollFinishSoundPlayer)
    }()

    func play() {
        Task {
            try? await Task.sleep(for: .seconds(1.0))
            audioPlayer?.drumRoll.play()
            try? await Task.sleep(for: .seconds(5.0))
            audioPlayer?.drumRollFinish.play()
        }
    }
}

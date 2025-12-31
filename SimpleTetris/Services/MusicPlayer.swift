import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var player: AVAudioPlayer?

    func playMusic() {
        guard let url = Bundle.main.url(forResource: "no_love", withExtension: "mp3") else { return }
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.numberOfLoops = -1
            self.player?.play()
        } catch {
            print("Failed to play music: \(error)")
        }
    }

    func stopMusic() {
        self.player?.stop()
    }
    
    func setVolume(_ volume: Float) {
        self.player?.volume = max(MinMusicVolume, min(MaxMusicVolume, volume))
    }
}

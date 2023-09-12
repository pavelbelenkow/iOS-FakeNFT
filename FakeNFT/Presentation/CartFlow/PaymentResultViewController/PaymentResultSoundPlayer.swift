import AVFoundation

struct PaymentResultSoundPlayer {
    private var player: AVAudioPlayer?
    
    init?(with fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Failed to load sound file")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print("Failed to create audio player with error: \(error.localizedDescription)")
        }
    }
    
    func play() {
        player?.play()
    }
}

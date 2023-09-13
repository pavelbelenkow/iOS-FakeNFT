import AVFoundation

/**
 Структура ``PaymentResultSoundPlayer`` отвечает за воспроизведение звуковых эффектов по результатам оплаты заказа
 - При инициализации передается имя файла со звуком, который будет воспроизводиться
 - Содержит метод для проигрывания звукового эффекта из переданного файла
 */
struct PaymentResultSoundPlayer {
    
    /// Экземпляр класса `AVAudioPlayer`, отвечающий за воспроизведение звука
    private var player: AVAudioPlayer?
    
    /**
     Создает новый объект ``PaymentResultSoundPlayer`` с указанным названием файла в проекте
     - Warning: Если файл не может быть загружен, объект не будет создан
     - Parameter fileName: Название файла с звуковым эффектом
     */
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
    
    /// Запускает воспроизведение звукового эффекта
    func play() {
        player?.play()
    }
}

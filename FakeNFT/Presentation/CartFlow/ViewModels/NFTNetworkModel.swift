import Foundation

/**
 Структура ``NFTNetworkModel`` представляет сетевую модель ``NFT``
 
 Содержит свойства для хранения информации об NFT
 */
struct NFTNetworkModel: Codable {

    /// Название NFT
    let name: String

    /// Массив ссылок на изображения NFT
    let images: [String]

    /// Рейтинг NFT (от 1 до 5)
    let rating: Int

    /// Цена NFT (в ETH - эфире)
    let price: Float

    /// Идентификатор NFT
    let id: String
}

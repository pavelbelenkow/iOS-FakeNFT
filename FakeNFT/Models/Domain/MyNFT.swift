import Foundation

/**
 Структура ``NFT`` представляет модель NFT, которая используется в приложении
 
 Содержит свойства для хранения информации об NFT
 */
struct MyNFT {

    /// Название NFT
    let name: String

    /// Ссылка на изображение NFT
    let image: String

    /// Рейтинг NFT (от 1 до 5)
    let rating: Int

    /// Цена NFT (в ETH - эфире)
    let price: Float

    /// Идентификатор NFT
    let id: String
}

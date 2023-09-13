import Foundation

/**
 Структура ``OrderNetworkModel`` представляет сетевую модель заказа
 
 Содержит свойства для хранения информации о заказе
 */
struct OrderNetworkModel: Codable {
    
    /// Массив ``NFT/id`` ``NFT``, входящих в заказ
    let nfts: [String]
}

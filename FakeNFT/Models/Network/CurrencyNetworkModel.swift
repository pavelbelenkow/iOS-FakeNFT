import Foundation

/**
 Структура ``CurrencyNetworkModel`` представляет сетевую модель ``Currency``
 
 Содержит свойства для хранения информации о валюте
 */
struct CurrencyNetworkModel: Codable {

    /// Название валюты
    let title: String

    /// Аббревиатура валюты (до 4х символов)
    let name: String

    /// Ссылка на изображение валюты
    let image: String

    /// Идентификатор валюты
    let id: String
}

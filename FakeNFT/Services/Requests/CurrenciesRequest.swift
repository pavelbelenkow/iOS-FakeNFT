import Foundation

/**
 Структура `CurrenciesRequest` представляет объект запроса на получение списка валют для оплаты

 Содержит свойства для формирования запроса на получение списка валют для оплаты
 */
struct CurrenciesRequest: NetworkRequest {
    
    /// URL-адрес конечной точки запроса
    var endpoint: URL? { URL(string: "\(baseEndpoint)currencies") }
    
    /// HTTP-метод запроса
    var httpMethod: HttpMethod = .get
}

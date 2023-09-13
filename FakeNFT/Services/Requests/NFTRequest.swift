import Foundation

/**
 Структура `NFTRequest` представляет объект запроса для получения NFT по id
 
 Содержит свойства для формирования запроса на получение NFT по id
 */
struct NFTRequest: NetworkRequest {
    
    /// Идентификатор NFT, который необходимо получить
    let id: String
    
    /// URL-адрес конечной точки запроса
    var endpoint: URL? { URL(string: "\(baseEndpoint)nft/\(id)") }
    
    /// HTTP-метод запроса
    var httpMethod: HttpMethod = .get
}

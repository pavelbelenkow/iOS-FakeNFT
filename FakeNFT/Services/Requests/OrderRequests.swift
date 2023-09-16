import Foundation

/**
 Структура `GetOrderRequest` представляет объект запроса на получение заказа
 
 Содержит свойства для формирования запроса на получение заказа
 */
struct GetOrderRequest: NetworkRequest {

    /// URL-адрес конечной точки запроса
    var endpoint: URL? { URL(string: "\(baseEndpoint)orders/1") }

    /// HTTP-метод запроса
    var httpMethod: HttpMethod = .get
}

/**
 Структура `PutOrderRequest` представляет объект запроса на обновление заказа
 
 Содержит свойства для формирования запроса на обновление заказа
 */
struct PutOrderRequest: NetworkRequest {

    /// URL-адрес конечной точки запроса
    var endpoint: URL? { URL(string: "\(baseEndpoint)orders/1") }

    /// HTTP-метод запроса
    var httpMethod: HttpMethod = .put

    /// Объект для передачи данных на сервер
    var dto: Encodable?
}

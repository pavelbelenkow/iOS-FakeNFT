import Foundation

/**
 Структура `OrderPaymentResultRequest` представляет объект запроса на получение результата оплаты заказа по id валюты

 Содержит свойства для формирования запроса на получение результата оплаты заказа по id валюты
 */
struct OrderPaymentResultRequest: NetworkRequest {

    /// Идентификатор валюты, с помощью которой оплачивается заказ
    let id: String

    /// URL-адрес конечной точки запроса
    var endpoint: URL? { URL(string: "\(baseEndpoint)orders/1/payment/\(id)") }

    /// HTTP-метод запроса
    var httpMethod: HttpMethod = .get
}

import Foundation

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(baseEndpoint)orders/1") }
    var httpMethod: HttpMethod = .get
}

struct PutOrderRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(baseEndpoint)orders/1") }
    var httpMethod: HttpMethod = .put
    var dto: Encodable?
}

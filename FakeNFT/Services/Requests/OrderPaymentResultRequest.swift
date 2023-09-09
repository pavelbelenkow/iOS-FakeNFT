import Foundation

struct OrderPaymentResultRequest: NetworkRequest {
    let id: String
    var endpoint: URL? { URL(string: "\(baseEndpoint)orders/1/payment/\(id)") }
    var httpMethod: HttpMethod = .get
}

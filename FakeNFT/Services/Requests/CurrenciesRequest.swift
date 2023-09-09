import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(baseEndpoint)currencies") }
    var httpMethod: HttpMethod = .get
}

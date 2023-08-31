import Foundation

struct NFTRequest: NetworkRequest {
    let id: String
    var endpoint: URL? { URL(string: "\(baseEndpoint)nft/\(id)") }
    var httpMethod: HttpMethod = .get
}

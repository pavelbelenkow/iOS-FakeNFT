import Foundation

struct UserInfoRequest: NetworkRequest {

    let id: Int

    init(id: Int) {
        self.id = id
    }

    var endpoint: URL? { URL(string: self.baseEndpoint + "users/\(id)") }

    var httpMethod: HttpMethod { .get }
}

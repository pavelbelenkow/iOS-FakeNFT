import Foundation

struct ProfileRequest: NetworkRequest {

    let id: Int

    init(id: Int) {
        self.id = id
    }

    var endpoint: URL? { URL(string: self.baseEndpoint + "profile/\(id)") }

    var httpMethod: HttpMethod { .get }
}

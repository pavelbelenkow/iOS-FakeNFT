import Foundation

struct UserInfoRequest: NetworkRequest {
    var endpoint: URL? {
        get {
            URL(string: self.baseEndpoint + "profile/1")
        }
    }

    var httpMethod: HttpMethod {
        get {
            .get
        }
    }
}

import Foundation

final class UserInfoNetworkService {
    private let client = DefaultNetworkClient()

    func getProfile(by id: Int, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        let request = UserInfoRequest(id: id)
        client.send(request: request, type: UserInfo.self, onResponse: completion)
    }
}

import Foundation

final class ProfileViewModel {
    private let userInfoNetworkService = UserInfoNetworkService()

    @Observable
    private(set) var user: UserInfo?

    init() {
        getUserInfo()
    }

    func getUserInfo() {
        userInfoNetworkService.getUserInfo { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

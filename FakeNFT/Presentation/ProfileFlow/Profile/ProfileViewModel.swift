import Foundation

final class ProfileViewModel {
    private let userInfoNetworkService = ProfileNetworkService()

    @Observable
    private(set) var user: Profile?

    init() {
        getUserInfo()
    }

    func getUserInfo() {
        userInfoNetworkService.getProfile(by: 1) { [weak self] result in
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

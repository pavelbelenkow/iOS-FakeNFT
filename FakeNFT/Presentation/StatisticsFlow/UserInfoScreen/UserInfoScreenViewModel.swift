//
//  UserInfoScreenViewModel.swift
//  FakeNFT
//
//  Created by REYNIKOV ANTON on 30.08.2023.
//

import Foundation

final class UserInfoScreenViewModel {
    private let infoUserNetReqService = InfoUserNetworkRequestService()
    
    @Observable
    private(set) var user: User? = nil
    
    func getInfoUser(userId: String) {
        infoUserNetReqService.getInfoUser(userId: userId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let infoUser):
                    self.user = infoUser
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setUserInfo() -> UserInfoSetModel {
        if
            let user = user,
            let url = URL(string: user.avatar) {
            return UserInfoSetModel(
                avatar: url,
                name: user.name,
                description: user.description,
                website: user.website
            )
        }
        return UserInfoSetModel(
            avatar: URL(fileURLWithPath: String()),
            name: String(),
            description: String(),
            website: String()
        )
    }
    
    func setCountCollectionNFT() -> Int {
        return user?.nfts.count ?? .zero
    }
}


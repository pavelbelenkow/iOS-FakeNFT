//
//  ChangedUserNetworkService.swift
//  FakeNFT
//
//  Created by D on 31.08.2023.
//

import Foundation

final class UserEditingNetworkService {
    private let client = DefaultNetworkClient()

    func getUserInfo(user: UserEditing, completion: @escaping (Result<UserEditing, Error>) -> Void) {
        let request = UserEditingRequest(userToUpdate: user)
        client.send(request: request, type: UserEditing.self, onResponse: completion)
    }
}
